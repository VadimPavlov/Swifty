//
//  FetchedResultsDataSource.swift
//  Created by Vadim Pavlov on 3/31/16.

import UIKit
import CoreData

open class FetchedResultsDataSource<Cell, Object: NSFetchRequestResult>: NSObject {
    
    open var frc: NSFetchedResultsController<Object>
    
    open let identifier: String
    open let configuration: Configuration
    public typealias Configuration = (_ cell: Cell, _ object: Object) -> Void
    
    public init(frc: NSFetchedResultsController<Object>, identifier: String = String(describing: Cell.self), configuration: @escaping Configuration) {
		self.frc = frc
        self.identifier = identifier
        self.configuration = configuration
        
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


open class CollectionFetchedResultsDataSource <Cell: UICollectionViewCell, Object: NSFetchRequestResult>: FetchedResultsDataSource<Cell, Object>, UICollectionViewDataSource, UICollectionViewDelegate {
	
	unowned var collectionView: UICollectionView
    weak var delegate: UICollectionViewDelegate?
    
    public init(_ collectionView: UICollectionView, frc: NSFetchedResultsController<Object>, identifier: String = String(describing: Cell.self), registerNib: Bool = false, configuration: @escaping Configuration) {
		self.collectionView = collectionView
		super.init(frc: frc, identifier: identifier, configuration: configuration)
		collectionView.dataSource = self
		if registerNib {
			let nib = UINib(nibName: identifier, bundle: nil)
			collectionView.register(nib, forCellWithReuseIdentifier: identifier)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.configuration(cell, object)
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
}

open class TableFetchedResultsDataSource <Cell: UITableViewCell, Object: NSFetchRequestResult>: FetchedResultsDataSource<Cell, Object>, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    unowned var tableView: UITableView
    weak var delegate: UITableViewDelegate?
    
    open var animationInsert: UITableViewRowAnimation = .automatic
    open var animationDelete: UITableViewRowAnimation = .automatic
    open var animationUpdate: UITableViewRowAnimation = .automatic
    
    public init(_ tableView: UITableView, frc: NSFetchedResultsController<Object>, identifier: String = String(describing: Cell.self), registerNib: Bool = false, configuration: @escaping Configuration) {
        self.tableView = tableView
        super.init(frc: frc, identifier: identifier, configuration: configuration)
        tableView.dataSource = self

        if registerNib {
            let nib = UINib(nibName: identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: identifier)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.configuration(cell, object)
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
