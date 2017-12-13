//
//  BatchUpdate.swift
//  Created by Vadim Pavlov on 2/21/17.

import Foundation
import CoreData

public struct Move<Index> {
    public let at: Index
    public let to: Index
}

public struct BatchUpdate: CustomStringConvertible {
   
    public var deleteSections: IndexSet
    public var insertSections: IndexSet
    public var reloadSections: IndexSet
    public var moveSections: [Move<Int>]
    
    public var deleteRows: [IndexPath]
    public var insertRows: [IndexPath]
    public var reloadRows: [IndexPath]
    public var moveRows: [Move<IndexPath>]


    public init(deleteSections: IndexSet = IndexSet(),
                insertSections: IndexSet = IndexSet(),
                reloadSections: IndexSet = IndexSet(),
                moveSections: [Move<Int>] = [],
                deleteRows: [IndexPath] = [],
                insertRows: [IndexPath] = [],
                reloadRows: [IndexPath] = [],
                moveRows: [Move<IndexPath>] = []) {
        
        self.deleteSections = deleteSections
        self.insertSections = insertSections
        self.reloadSections = reloadSections
        self.moveSections = moveSections
        self.deleteRows = deleteRows
        self.insertRows = insertRows
        self.reloadRows = reloadRows
        self.moveRows = moveRows
    }
    
    public var description: String {
        var operations: [String] = []
        
        operations.append(contentsOf: deleteSections.map { "Delete section: \($0)" })
        operations.append(contentsOf: insertSections.map { "Insert sections: \($0)" })
        operations.append(contentsOf: reloadSections.map {  "Reload section: \($0)" })
        operations.append(contentsOf: moveSections.map { "Move section at: \($0.at) to: \($0.to)" })
        
        operations.append(contentsOf: deleteRows.map { "Delete row at: \($0)" })
        operations.append(contentsOf: insertRows.map { "Insert row at: \($0)" })
        operations.append(contentsOf: reloadRows.map { "Reload row at: \($0)" })
        operations.append(contentsOf: moveRows.map { "Move row at: \($0.at) to: \($0.to)" })
        
        return operations.joined(separator: "\n")
    }
    
    var isSectionsUpdate: Bool {
        return !deleteSections.isEmpty || !insertSections.isEmpty || !reloadSections.isEmpty
    }

}

// FRC Helpers
public extension BatchUpdate {
    public mutating func addSection(type: NSFetchedResultsChangeType, index: Int) {
        switch type {
        case .insert: insertSections.insert(index)
        case .delete: deleteSections.insert(index)
        case .update, .move: fatalError("Not supported cases")
        }
    }
    
    public mutating func addRow(type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?) {
        guard let ip = newIndexPath ?? indexPath else { return }
        
        switch type {
        case .insert:
            insertRows.append(ip)
        case .delete:
            deleteRows.append(ip)
        case .update:
            reloadRows.append(ip)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            if indexPath == newIndexPath {
                reloadRows.append(ip)
            } else {
                let move = Move(at: indexPath, to: newIndexPath)
                moveRows.append(move)
            }
        }
    }
}
