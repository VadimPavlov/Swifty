//
//  TestDataSource.swift
//  SwiftyTests
//
//  Created by Vadym Pavlov on 02.04.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
import CoreData
@testable import Swifty

final class TestEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestEntity> {
        return NSFetchRequest<TestEntity>(entityName: "TestEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
}


class TestDataSource: XCTestCase {

//    let delegate = FRCDelegate()

    func testEmpty() {
        let ds = DataSource([])

        XCTAssertEqual(ds.numberOfSection(), 1)
        XCTAssertEqual(ds.numberOfObjectsInSection(0), 0)
    }

    func testArray() {
        let array = ["1", "2", "3", "4", "5"]

        let ds = DataSource(array)

        XCTAssertEqual(ds.numberOfSection(), 1)
        XCTAssertEqual(ds.numberOfObjectsInSection(0), 5)
    }

    func testSections() {
        let section1 = Section(title: "First", objects: [0,1,2])
        let section2 = Section(title: "Second", objects: [3,4])

        let ds = DataSource(sections: [section1, section2])

        XCTAssertEqual(ds.numberOfSection(), 2)
        XCTAssertEqual(ds.numberOfObjectsInSection(0), 3)
        XCTAssertEqual(ds.numberOfObjectsInSection(1), 2)

        XCTAssertEqual(ds.titleInSection(0), "First")
        XCTAssertEqual(ds.titleInSection(1), "Second")
    }

    lazy var testContainer: NSPersistentContainer = {
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType

        let container = NSPersistentContainer(name: "Swifty")
        container.persistentStoreDescriptions = [desc]
        container.loadPersistentStores { desc, error in
            precondition(error == nil)
            precondition(desc.type == NSInMemoryStoreType)
        }
        return container
    }()

    func testEmptyFRC() {
        let container = self.testContainer
        let context = container.viewContext
        let request: NSFetchRequest<TestEntity> = TestEntity.fetchRequest()
        let sortKey = #keyPath(TestEntity.priority)
        let sort = NSSortDescriptor(key: sortKey, ascending: true)
        request.sortDescriptors = [sort]

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let ds = DataSource(frc: frc)

        XCTAssertEqual(ds.numberOfSection(), 0)
        XCTAssertEqual(ds.numberOfObjectsInSection(0), 0)
    }


    func testFRC() {
        let container = self.testContainer
        let context = container.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "TestEntity", in: context)!

        _ = TestEntity(entity: entity, insertInto: context) // insert 1 object

        let request: NSFetchRequest<TestEntity> = TestEntity.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(TestEntity.priority), ascending: true)
        request.sortDescriptors = [sort]

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        let ds = DataSource(frc: frc)

        try? frc.performFetch()

        XCTAssertEqual(ds.numberOfSection(), 1)
        XCTAssertEqual(ds.numberOfObjectsInSection(0), 1)
    }

    func testFRCSections() {
        let container = self.testContainer
        let context = container.viewContext

        // insert few objects
        let entity = NSEntityDescription.entity(forEntityName: "TestEntity", in: context)!
        let object1 = TestEntity(entity: entity, insertInto: context)
        let object2 = TestEntity(entity: entity, insertInto: context)
        let object3 = TestEntity(entity: entity, insertInto: context)

        object1.name = "Section1"
        object2.name = "Section2"
        object3.name = "Section2"

        let request: NSFetchRequest<TestEntity> = TestEntity.fetchRequest()
        let groupKey = #keyPath(TestEntity.name)
        let sort = NSSortDescriptor(key: groupKey, ascending: true)
        request.sortDescriptors = [sort]

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: groupKey, cacheName: nil)
        let ds = DataSource(frc: frc)

        try! frc.performFetch()

        XCTAssertEqual(ds.numberOfSection(), 2)
        XCTAssertEqual(ds.numberOfObjectsInSection(0), 1)
        XCTAssertEqual(ds.numberOfObjectsInSection(1), 2)

        XCTAssertEqual(ds.titleInSection(0), "Section1")
        XCTAssertEqual(ds.titleInSection(1), "Section2")
    }
}
