//
//  FRCTableController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit
import CoreData

public class FRCTableController<Object: NSFetchRequestResult>: TableController<Object>, NSFetchedResultsControllerDelegate {

    public var animation: UITableViewRowAnimation = .automatic
    
    public init(tableView: UITableView, frc: NSFetchedResultsController<Object>, cellDescriptor: @escaping (Object) -> CellDescriptor) {
        let dataSource = DataSource(frc: frc)
        super.init(tableView: tableView, dataSource: dataSource, cellDescriptor: cellDescriptor)
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

public class SimpleFRCTableController<Object: NSFetchRequestResult, Cell: UITableViewCell>: FRCTableController<Object> {
    public init(tableView: UITableView, frc: NSFetchedResultsController<Object>, identifier: String? = nil, register: CellDescriptor.Register? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(tableView: tableView, frc: frc) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
