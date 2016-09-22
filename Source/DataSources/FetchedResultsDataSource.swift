//
//  FetchedResultsDataSource.swift
//  Created by Vadim Pavlov on 3/31/16.

import UIKit
import CoreData

open class FetchedResultsDataSource<Cell, Object: NSFetchRequestResult>: NSObject {
    
    open var frc: NSFetchedResultsController<Object>
    
    open let cellIdentifier: String
    open let cellConfiguration: CellConfiguration
    public typealias CellConfiguration = (_ cell: Cell, _ object: Object) -> Void
    
    public init(frc: NSFetchedResultsController<Object>, cellIdentifier: String = String(describing: Cell.self), cellConfiguration: @escaping CellConfiguration) {
		self.frc = frc
        self.cellIdentifier = cellIdentifier
        self.cellConfiguration = cellConfiguration
        
        _ = try? frc.performFetch()

    }
    
    open func numberOfSections() -> Int {
        return self.frc.sections?.count ?? 0
    }
    
    open func sectionInfoForSection(_ section: Int) -> NSFetchedResultsSectionInfo? {
        return self.frc.sections?[section]
    }
    
    open func objectAtIndexPath(_ indexPath: IndexPath) -> Object? {
        return self.frc.object(at: indexPath) as? Object
    }
}



protocol SupplementaryElementType {
    associatedtype View
    var identifier: String { get }
    func configuration(_ view: View, sectionInfo: NSFetchedResultsSectionInfo)
}

open class CollectionFetchedResultsDataSource <Cell: UICollectionViewCell, Object: NSFetchRequestResult>: FetchedResultsDataSource<Cell, Object>, UICollectionViewDataSource, UICollectionViewDelegate {
	
	unowned var collectionView: UICollectionView
    weak var delegate: UICollectionViewDelegate?
    
    public init(_ collectionView: UICollectionView, frc: NSFetchedResultsController<Object>, cellIdentifier: String = String(describing: Cell.self), registerNib: Bool = false, cellConfiguration: @escaping CellConfiguration) {
		self.collectionView = collectionView
		super.init(frc: frc, cellIdentifier: cellIdentifier, cellConfiguration: cellConfiguration)
		collectionView.dataSource = self
		if registerNib {
			let nib = UINib(nibName: cellIdentifier, bundle: nil)
			collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
		}
    }
    
    // MARK: - UICollectionViewDataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections()
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.cellConfiguration(cell, object)
        return cell
    }
   
    // MARK: - UICollectionViewDelegate
    open var didSelectObject: ((Object, IndexPath) -> Void)? {
        didSet {
            delegate = collectionView.delegate
            collectionView.delegate = self
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        
        if let object = objectAtIndexPath(indexPath) {
            didSelectObject?(object, indexPath)
        }
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

open class TableFetchedResultsDataSource <Cell: UITableViewCell, Object: NSFetchRequestResult>: FetchedResultsDataSource<Cell, Object>, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    unowned var tableView: UITableView
    weak var delegate: UITableViewDelegate?
    
    open var animationInsert: UITableViewRowAnimation = .automatic
    open var animationDelete: UITableViewRowAnimation = .automatic
    open var animationUpdate: UITableViewRowAnimation = .automatic
    
    public init(_ tableView: UITableView, frc: NSFetchedResultsController<Object>, cellIdentifier: String = String(describing: Cell.self), registerNib: Bool = false, cellConfiguration: @escaping CellConfiguration) {
        self.tableView = tableView
        super.init(frc: frc, cellIdentifier: cellIdentifier, cellConfiguration: cellConfiguration)
        tableView.dataSource = self

        if registerNib {
            let nib = UINib(nibName: cellIdentifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        }

    }
		
    // MARK: - UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let s = self.numberOfSections()
        let rws = self.tableView(tableView, numberOfRowsInSection: 0)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.cellConfiguration(cell, object)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    open var didSelectObject: ((Object, IndexPath) -> Void)? {
        didSet {
            delegate = tableView.delegate
            tableView.delegate = self
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        if let object = objectAtIndexPath(indexPath) {
            didSelectObject?(object, indexPath)
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let sections = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: self.tableView.insertSections(sections, with: animationInsert)
        case .delete: self.tableView.deleteSections(sections, with: animationDelete)
        case .update, .move: fatalError("Not supported cases")
        }
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath { self.tableView.insertRows(at: [indexPath], with: animationInsert) }
        case .delete:
            if let indexPath = indexPath { self.tableView.deleteRows(at: [indexPath], with: animationDelete) }
        case .update:
            if let indexPath = indexPath { self.tableView.reloadRows(at: [indexPath], with: animationUpdate) }
        case .move:
            if  let indexPath = indexPath,
                let newIndexPath = newIndexPath {
                // https://forums.developer.apple.com/thread/4999
                if indexPath == newIndexPath {
                    self.tableView.reloadRows(at: [indexPath], with: animationUpdate)
                } else {
                    self.tableView.moveRow(at: indexPath, to: newIndexPath)
                    DispatchQueue.main.async {
                        [weak self] in
                        self?.tableView.reloadRows(at: [newIndexPath], with: self?.animationUpdate ?? .automatic)
                    }
                }
            }
        }
    }
}
