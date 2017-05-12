//
//  BatchUpdate.swift
//  Created by Vadim Pavlov on 2/21/17.

import Foundation
import CoreData

public struct Move<Index> {
    let at: Index
    let to: Index
}

public struct BatchUpdate {
    let insertSections: IndexSet?
    let reloadSections: IndexSet?
    let deleteSections: IndexSet?
    
    let insertRows: [IndexPath]?
    let reloadRows: [IndexPath]?
    let deleteRows: [IndexPath]?
    
    let moveSection: Move<Int>?
    let moveRow: Move<IndexPath>?
    
    public init(insertSections: IndexSet? = nil,
         reloadSections: IndexSet? = nil,
         deleteSections: IndexSet? = nil,
         insertRows: [IndexPath]? = nil,
         reloadRows: [IndexPath]? = nil,
         deleteRows: [IndexPath]? = nil,
         moveSection: Move<Int>? = nil,
         moveRow: Move<IndexPath>? = nil) {
        
        self.insertSections = insertSections
        self.reloadSections = reloadSections
        self.deleteSections = deleteSections
        self.insertRows = insertRows
        self.reloadRows = reloadRows
        self.deleteRows = deleteRows
        self.moveSection = moveSection
        self.moveRow = moveRow
    }
}

// FRC Helpers
public extension BatchUpdate {
    public init(sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let sections = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert: self.init(insertSections: sections)
        case .delete: self.init(deleteSections: sections)
        case .update, .move: fatalError("Not supported cases")
        }
    }
    
    public static func perform(at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?, perform: @escaping (BatchUpdate) -> Void) {
        
        guard let ip = newIndexPath ?? indexPath else { return }
        
        let update: BatchUpdate
        
        switch type {
        case .insert:
            update = BatchUpdate(insertRows: [ip])
        case .delete:
            update = BatchUpdate(deleteRows: [ip])
        case .update:
            update = BatchUpdate(reloadRows: [ip])
            
        case .move:
            // https://forums.developer.apple.com/thread/4999
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            if indexPath == newIndexPath {
                update = BatchUpdate(reloadRows: [ip])
            } else {
                let move = Move(at: indexPath, to: newIndexPath)
                update = BatchUpdate(moveRow: move)

                DispatchQueue.main.async {
                    let reload = BatchUpdate(reloadRows: [newIndexPath])
                    perform(reload)
                }
            }
        }
        perform(update)        
    }
}
