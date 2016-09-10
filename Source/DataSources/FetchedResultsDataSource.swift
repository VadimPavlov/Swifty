//
//  FetchedResultsDataSource.swift
//  Created by Vadim Pavlov on 3/31/16.

import UIKit
import CoreData

public class FetchedResultsDataSource<Cell, Object>: NSObject {
    
    public var frc: NSFetchedResultsController?
    public let cellIdentifier: String
    public let cellConfiguration: CellConfiguration
    public typealias CellConfiguration = (cell: Cell, object: Object) -> Void
    
    public init(frc: NSFetchedResultsController? = nil, cellIdentifier: String = String(Cell), cellConfiguration: CellConfiguration) {
		self.frc = frc
        self.cellIdentifier = cellIdentifier
        self.cellConfiguration = cellConfiguration
    }
    
    public func numberOfSections() -> Int {
        return self.frc?.sections?.count ?? 0
    }
    
    public func sectionInfoForSection(section: Int) -> NSFetchedResultsSectionInfo? {
        return self.frc?.sections?[section]
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> Object? {
        return self.frc?.objectAtIndexPath(indexPath) as? Object
    }
}



protocol SupplementaryElementType {
    associatedtype View
    var identifier: String { get }
    func configuration(view: View, sectionInfo: NSFetchedResultsSectionInfo)
}

public class CollectionFetchedResultsDataSource <Cell: UICollectionViewCell, Object>: FetchedResultsDataSource<Cell, Object>, UICollectionViewDataSource, UICollectionViewDelegate {
	
	weak var collectionView: UICollectionView?

    
	public init(_ collectionView: UICollectionView, frc: NSFetchedResultsController? = nil, cellIdentifier: String = String(Cell), registerNib: Bool = false, cellConfiguration: CellConfiguration) {
		self.collectionView = collectionView
		super.init(frc: frc, cellIdentifier: cellIdentifier, cellConfiguration: cellConfiguration)
		collectionView.dataSource = self
		if registerNib {
			let nib = UINib(nibName: cellIdentifier, bundle: nil)
			collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
		}
    }	
    
	public var didSelectObject: ((Object, NSIndexPath) -> Void)? {
		willSet { collectionView?.delegate = newValue != nil ? self : nil }
	}
    
    
	// MARK: - UICollectionViewDelegate
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if let object = objectAtIndexPath(indexPath) {
			didSelectObject?(object, indexPath)
		}
	}

    // MARK: - UICollectionViewDataSource
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfSections()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier, forIndexPath: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.cellConfiguration(cell: cell, object: object)
        return cell
    }
    
    
//    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var view: UIView?
//        if let identifier = self.elementType?.identifier {
//            view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath) as! CollectionElementType.Element
//            let info = self.sectionInfoForSection(indexPath.section)!
//            self.elementConfiguration?(element: view, sectionInfo: info)
//        }
//        return view
//    }
    
    // TODO: NSFetchedResultsControllerDelegate
}

public class TableFetchedResultsDataSource <Cell: UITableViewCell, Object>: FetchedResultsDataSource<Cell, Object>, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    weak var tableView: UITableView?
    
    public var animationInsert: UITableViewRowAnimation = .Automatic
    public var animationDelete: UITableViewRowAnimation = .Automatic
    public var animationUpdate: UITableViewRowAnimation = .Automatic
    
    public init(_ tableView: UITableView, frc: NSFetchedResultsController? = nil, cellIdentifier: String = String(Cell), cellConfiguration: CellConfiguration) {
        self.tableView = tableView
        super.init(frc: frc, cellIdentifier: cellIdentifier, cellConfiguration: cellConfiguration)
        tableView.dataSource = self
    }
	
	public var didSelectObject: ((Object, NSIndexPath) -> Void)? {
		willSet { tableView?.delegate = newValue != nil ? self : nil }
	}
	
	// MARK: - UITableViewDelegate
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let object = objectAtIndexPath(indexPath) {
			didSelectObject?(object, indexPath)
		}
	}
	
    // MARK: - UITableViewDataSource
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let s = self.numberOfSections()
        let rws = self.tableView(tableView, numberOfRowsInSection: 0)
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.cellConfiguration(cell: cell, object: object)
        return cell
    }

    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.beginUpdates()
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.endUpdates()
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        let sections = NSIndexSet(index: sectionIndex)
        switch type {
        case .Insert: self.tableView?.insertSections(sections, withRowAnimation: .Automatic)
        case .Delete: self.tableView?.deleteSections(sections, withRowAnimation: .Automatic)
        case .Update, .Move: fatalError("Not supported cases")
        }
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let indexPath = newIndexPath { self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: animationInsert) }
        case .Delete:
            if let indexPath = indexPath { self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animationDelete) }
        case .Update:
            if let indexPath = indexPath { self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: animationUpdate) }
        case .Move:
            if  let indexPath = indexPath, let newIndexPath = newIndexPath {
                // https://forums.developer.apple.com/thread/4999
                if indexPath == newIndexPath {
                    self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: animationUpdate)
                } else {
                    self.tableView?.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
                    dispatch_async(dispatch_get_main_queue()) {
                        [weak self] in
                        self?.tableView?.reloadRowsAtIndexPaths([newIndexPath], withRowAnimation: self?.animationUpdate ?? .Automatic)
                    }
                }
            }
        }
    }
}