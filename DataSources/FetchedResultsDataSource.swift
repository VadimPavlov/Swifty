//
//  FetchedResultsDataSource.swift
//  SwiftCourse
//
//  Created by Vadim Pavlov on 3/31/16.
//  Copyright © 2016 DataArt. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsDataSource<Cell, Object>: NSObject {
    
    let identifier: String
    let frc: NSFetchedResultsController
    let configuration: Configuration
    typealias Configuration = (cell: Cell, object: Object) -> Void

    init(frc: NSFetchedResultsController, identifier: String = String(Cell), configuration: Configuration) {
        self.frc = frc
        self.identifier = identifier
        self.configuration = configuration
    }
    
    func numberOfSections() -> Int {
        return self.frc.sections?.count ?? 0
    }
    
    func sectionInfoForSection(section: Int) -> NSFetchedResultsSectionInfo? {
        return self.frc.sections?[section]
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object? {
        return self.frc.objectAtIndexPath(indexPath) as? Object
    }
}

class CollectionFetchedResultsDataSource <Cell: UICollectionViewCell, Object>: FetchedResultsDataSource<Cell, Object>, UICollectionViewDataSource {
    
    override init(frc: NSFetchedResultsController, identifier: String = String(Cell), configuration: Configuration) {
        super.init(frc: frc, identifier: identifier, configuration: configuration)
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfSections()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.identifier, forIndexPath: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.configuration(cell: cell, object: object)
        return cell
    }
    // TODO: NSFetchedResultsControllerDelegate
}

class TableFetchedResultsDataSource <Cell: UITableViewCell, Object>: FetchedResultsDataSource<Cell, Object>, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    weak var tableView: UITableView?
    init(tableView: UITableView, frc: NSFetchedResultsController, identifier: String = String(Cell), configuration: Configuration) {
        self.tableView = tableView
        super.init(frc: frc, identifier: identifier, configuration: configuration)
        tableView.dataSource = self
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionInfoForSection(section)?.numberOfObjects ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier, forIndexPath: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        guard let object = self.objectAtIndexPath(indexPath) else { fatalError("Missing object at \(indexPath)") }
        self.configuration(cell: cell, object: object)
        return cell
    }

    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView?.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        let sections = NSIndexSet(index: sectionIndex)
        switch type {
        case .Insert: self.tableView?.insertSections(sections, withRowAnimation: .Automatic)
        case .Delete: self.tableView?.deleteSections(sections, withRowAnimation: .Automatic)
        case .Update, .Move: fatalError("Not supported cases")
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let indexPath = newIndexPath { self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic) }
        case .Delete:
            if let indexPath = indexPath { self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic) }
        case .Update:
            if let indexPath = indexPath { self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic) }
        case .Move:
            if  let indexPath = indexPath, let newIndexPath = newIndexPath {
                // https://forums.developer.apple.com/thread/4999
                if indexPath == newIndexPath {
                    self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                } else {
                    self.tableView?.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
                    dispatch_async(dispatch_get_main_queue()) {
                        [weak self] in
                        self?.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    }
                }
            }
        }
    }
}