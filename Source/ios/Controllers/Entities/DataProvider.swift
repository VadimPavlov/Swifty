//
//  DataProvider.swift
//  Swifty
//
//  Created by Vadym Pavlov on 09.06.2018.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation
import CoreData
import Photos

public struct Section<A> {
    public let title: String?
    public let objects: [A]

    public init(title: String? = nil, objects: [A]) {
        self.title = title
        self.objects = objects
    }
}

public final class DataProvider<Object>: ExpressibleByArrayLiteral {
    public let numberOfSection: () -> Int
    public let numberOfObjectsInSection: (Int) -> Int
    public let objectAtIndexPath: (IndexPath) -> Object
    public let titleInSection: (Int) -> String?

    public convenience init(arrayLiteral elements: Object...) {
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

    private init(numberOfSection: @escaping () -> Int,
         numberOfObjectsInSection: @escaping (Int) -> Int,
         objectAtIndexPath: @escaping (IndexPath) -> Object,
         titleInSection: @escaping (Int) -> String?) {

        self.numberOfSection = numberOfSection
        self.numberOfObjectsInSection = numberOfObjectsInSection
        self.objectAtIndexPath = objectAtIndexPath
        self.titleInSection = titleInSection
    }

}

public extension DataProvider where Object: AnyObject {
    convenience init(result: PHFetchResult<Object>) {
        self.init(numberOfSection: { 1 },
                  numberOfObjectsInSection: { _ in return result.count },
                  objectAtIndexPath: { return result.object(at: $0.row) },
                  titleInSection: { _ in return nil })
    }
}

public extension DataProvider where Object: NSFetchRequestResult {

    convenience init(frc: NSFetchedResultsController<Object>, emptySectionsCount: Int = 0) {
        self.init(numberOfSection: { frc.sections?.count ?? emptySectionsCount },
                  numberOfObjectsInSection: { frc.sections?[$0].numberOfObjects ?? 0 },
                  objectAtIndexPath: { frc.sections?[$0.section].objects?[$0.row] as! Object },
                  titleInSection: { frc.sections?[$0].name })
    }
}

