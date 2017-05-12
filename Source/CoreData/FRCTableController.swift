//
//  FRCTableController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit
import CoreData

public class FRCTableController<Cell: UITableViewCell, Object: NSFetchRequestResult>: TableController<Cell, Object>, NSFetchedResultsControllerDelegate {

    var animation: UITableViewRowAnimation = .automatic
    
    public init(tableView: UITableView, frc: NSFetchedResultsController<Object>, config: Config<Cell, Object>) {
        let dataSource = DataSource(frc: frc)
        super.init(tableView: tableView, dataSource: dataSource, config: config)
        frc.delegate = self
    }    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let update = BatchUpdate(sectionIndex: sectionIndex, for: type)
        self.performBatch(update, animation: animation)
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
        BatchUpdate.perform(at: indexPath, for: type, newIndexPath: newIndexPath) {
            self.performBatch($0, animation: self.animation)
        }
    }
}

public extension FRCTableController {
    public convenience init(tableView: UITableView, frc: NSFetchedResultsController<Object>, setup: @escaping Config<Cell, Object>.Setup) {
        let config = Config(setup: setup)
        self.init(tableView: tableView, frc: frc, config: config)
    }
}
