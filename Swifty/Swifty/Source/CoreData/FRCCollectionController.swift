//
//  FRCCollectionController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit
import CoreData

public class FRCCollectionController<Cell: UICollectionViewCell, Object: NSFetchRequestResult>: CollectionController<Cell, Object>, NSFetchedResultsControllerDelegate {
    
    init(collectionView: UICollectionView, frc: NSFetchedResultsController<Object>, config: Config<Cell, Object>) {
        let dataSource = DataSource(frc: frc)
        super.init(collectionView: collectionView, dataSource: dataSource, config: config)
        frc.delegate = self
    }    
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let update =  BatchUpdate(sectionIndex: sectionIndex, for: type)
        self.performBatch(update)
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        BatchUpdate.perform(at: indexPath, for: type, newIndexPath: newIndexPath) {
            self.performBatch($0)
        }
        
    }
}

public extension FRCCollectionController {
    public convenience init(collectionView: UICollectionView, frc: NSFetchedResultsController<Object>, setup: @escaping Config<Cell, Object>.Setup) {
        let config = Config(setup: setup)
        self.init(collectionView: collectionView, frc: frc, config: config)
    }
}
