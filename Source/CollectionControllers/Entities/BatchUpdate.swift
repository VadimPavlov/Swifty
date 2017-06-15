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
    public init(type: NSFetchedResultsChangeType, sectionIndex: Int) {
        let sections = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert: self.init(insertSections: sections)
        case .delete: self.init(deleteSections: sections)
        case .update, .move: fatalError("Not supported cases")
        }
    }
    
    public init?(type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?) {
        guard let ip = newIndexPath ?? indexPath else { return nil }
        
        switch type {
        case .insert:
            self.init(insertRows: [ip])
        case .delete:
            self.init(deleteRows: [ip])
        case .update:
            self.init(reloadRows: [ip])
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return nil }
            if indexPath == newIndexPath {
                self.init(reloadRows: [ip])
            } else {
                let move = Move(at: indexPath, to: newIndexPath)
                self.init(moveRow: move)
            }
        }
    }
}
