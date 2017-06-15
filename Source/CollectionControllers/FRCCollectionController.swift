//
//  FRCCollectionController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit
import CoreData

public class FRCCollectionController<Object: NSFetchRequestResult>: CollectionController<Object>, NSFetchedResultsControllerDelegate {
    
    private let frc: NSFetchedResultsController<Object>
    private let observingPredicate: Bool
    private var updates: [BatchUpdate] = []

    public init(collectionView: UICollectionView? = nil, frc: NSFetchedResultsController<Object>, observeRequestPredicate: Bool = true, cellDescriptor: @escaping (Object) -> CellDescriptor) {

        self.frc = frc
        self.observingPredicate = observeRequestPredicate

        let dataSource = DataSource(frc: frc)
        super.init(collectionView: collectionView, dataSource: dataSource, cellDescriptor: cellDescriptor)
        frc.delegate = self
        
        if observeRequestPredicate {
            frc.fetchRequest.addObserver(self, forKeyPath: "predicate", options: .new, context: nil)
        }
    }
    
    deinit {
        if observingPredicate {
            frc.fetchRequest.removeObserver(self, forKeyPath: "predicate")
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.performBatch(updates: updates)
        updates.removeAll()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let update =  BatchUpdate(type: type, sectionIndex: sectionIndex)
        updates.append(update)
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let update = BatchUpdate(type: type, indexPath: indexPath, newIndexPath: newIndexPath) {
            updates.append(update)
        }
    }
}

public class SimpleFRCCollectionController<Object: NSFetchRequestResult, Cell: UICollectionViewCell>: FRCCollectionController<Object>  {
    public init(collectionView: UICollectionView? = nil, frc: NSFetchedResultsController<Object>, observeRequestPredicate: Bool = true, identifier: String? = nil, register: CellDescriptor.Register? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(collectionView: collectionView, frc: frc, observeRequestPredicate: observeRequestPredicate) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
