//
//  UIView.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation
import CoreData

public struct Section<A> {
    let title: String?
    let objects: [A]
}

public struct DataSource<Object>: ExpressibleByArrayLiteral, Equatable {
    
    private let id = UUID()
    
    public let numberOfSection: () -> Int
    public let numberOfObjectsInSection: (Int) -> Int
    public let objectAtIndexPath: (IndexPath) -> Object
    public let titleInSection: (Int) -> String?

    public init(arrayLiteral elements: Object...) {
        self.init(elements)
    }
    
    public init(_ array: [Object]) {
        self.numberOfSection = { 1 }
        self.numberOfObjectsInSection = { _ in array.count }
        self.titleInSection = { _ in return nil }
        self.objectAtIndexPath = { array[$0.row] }
    }
    
    public init(sections: [Section<Object>]) {
        self.numberOfSection = { sections.count }
        self.numberOfObjectsInSection = { sections[$0].objects.count }
        self.titleInSection = { sections[$0].title }
        self.objectAtIndexPath = { sections[$0.section].objects[$0.row] }
    }
    
    public static func ==(lhs: DataSource<Object>, rhs: DataSource<Object>) -> Bool {
        return lhs.id == rhs.id
    }
    
}

public extension DataSource where Object: NSFetchRequestResult {

    public init(frc: NSFetchedResultsController<Object>, emptySectionsCount: Int = 0) {
        self.numberOfSection = { frc.sections?.count ?? emptySectionsCount }
        self.numberOfObjectsInSection = { frc.sections?[$0].numberOfObjects ?? 0 }
        self.titleInSection = { frc.sections?[$0].name }
        self.objectAtIndexPath = { frc.sections?[$0.section].objects?[$0.row] as! Object }
    }
}
