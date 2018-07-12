//
//  FRCCollectionController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit
import CoreData

open class FRCCellsCollectionController<Object: NSFetchRequestResult>: CellsCollectionController<Object>, NSFetchedResultsControllerDelegate {
    
    public let frc: NSFetchedResultsController<Object>
    public var frcUpdate: BatchUpdate?

    private var predicateToken: NSKeyValueObservation?
    
    public init(collectionView: UICollectionView, frc: NSFetchedResultsController<Object>, observePredicate: Bool = true, cellDescriptor: @escaping (Object) -> CellDescriptor) {

        self.frc = frc
        let provider = DataProvider(frc: frc)
        super.init(collectionView: collectionView, provider: provider, cellDescriptor: cellDescriptor)
        frc.delegate = self
        
        if observePredicate {
            predicateToken = frc.fetchRequest.observe(\.predicate) { request, change in
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    deinit {
        predicateToken?.invalidate()
    }

    open func frcIndexPath(for indexPath: IndexPath) -> IndexPath {
        return indexPath
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    open func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        frcUpdate = BatchUpdate()
    }
    
    open func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let update = self.frcUpdate else { return }
        self.performBatch(update)
        self.frcUpdate = nil
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        frcUpdate?.addSection(type: type, index: sectionIndex)
    }
    
    open func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let old = indexPath.map(frcIndexPath)
        let new = newIndexPath.map(frcIndexPath)
        frcUpdate?.addRow(type: type, indexPath: old, newIndexPath: new)
    }

}

open class FRCCollectionController<Object: NSFetchRequestResult, Cell: UICollectionViewCell>: FRCCellsCollectionController<Object>  {
    public init(collectionView: UICollectionView, frc: NSFetchedResultsController<Object>, observePredicate: Bool = true, identifier: String? = nil, register: Register? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(collectionView: collectionView, frc: frc, observePredicate: observePredicate) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
