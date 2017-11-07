//
//  FRCCollectionController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit
import CoreData

open class FRCCellsCollectionController<Object: NSFetchRequestResult>: CellsCollectionController<Object>, NSFetchedResultsControllerDelegate {
    
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
    
    open func adaptedIndexPath(for indexPath: IndexPath) -> IndexPath {
        return indexPath
    }
    
    override open func object(at indexPath: IndexPath) -> Object {
        let ip = adaptedIndexPath(for: indexPath)
        return super.object(at: ip)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.performBatch(updates: updates)
        updates.removeAll()
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let update =  BatchUpdate(type: type, sectionIndex: sectionIndex)
        updates.append(update)
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let old = indexPath.map(adaptedIndexPath)
        let new = newIndexPath.map(adaptedIndexPath)
        if let update = BatchUpdate(type: type, indexPath: old, newIndexPath: new) {
            updates.append(update)
        }
    }
    
    // MARK: - Observing
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }

}

open class FRCCollectionController<Object: NSFetchRequestResult, Cell: UICollectionViewCell>: FRCCellsCollectionController<Object>  {
    public init(collectionView: UICollectionView? = nil, frc: NSFetchedResultsController<Object>, observeRequestPredicate: Bool = true, identifier: String? = nil, register: CellDescriptor.Register? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(collectionView: collectionView, frc: frc, observeRequestPredicate: observeRequestPredicate) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
