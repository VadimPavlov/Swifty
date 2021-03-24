//
//  TestListController.swift
//  SwiftyTests
//
//  Created by Vadim Pavlov on 8/9/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
@testable import Swifty

final class TestListController: XCTestCase {

    var list: ListController!
    var view: CollectionListView!

    override func setUp() {
        super.setUp()

        let layoyt = UICollectionViewFlowLayout()
        view = CollectionListView(collectionViewLayout: layoyt)
        list = ListController(pageSize: 10, firstPage: 0)
        list.setView(view)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUpdate() {

        XCTAssertFalse(view.isViewLoaded)

        list.updateState()
        XCTAssertFalse(view.stateUpdated)

        list.updateList()
        XCTAssertFalse(view.listUpdated)

        // load view
        _ = view.view

        XCTAssertTrue(view.isViewLoaded)

        list.updateState()
        XCTAssertTrue(view.stateUpdated)

        list.updateList()
        XCTAssertTrue(view.listUpdated)
    }


    // MARK: - Inserting
    func testAppending() {
        // load view
        _ = view.view

        let to1 = TestObject(id: "1")
        let to2 = TestObject(id: "2")
        let to3 = TestObject(id: "3")

        list.appendObjects([to1, to2, to3])

        XCTAssertEqual(view.list.count, 3)
        XCTAssertEqual(view.batch?.insertRows.count, 3)

        let to4 = TestObject(id: "4")
        let to5 = TestObject(id: "5")
        let to6 = TestObject(id: "6")

        list.appendObjects([to4, to5, to6])

        XCTAssertEqual(view.list.count, 6)
        XCTAssertEqual(view.batch?.insertRows.count, 3)

    }

    // MARK: - Deletion
}


// MARK: - Helpers

struct TestObject: ListObject {
    let id: String

    var listID: String {
        return id
    }
}

final class CollectionListView: UICollectionViewController, ListViewType {

    var stateUpdated = false
    var listUpdated = false

    var list: [TestObject] = []
    var batch: BatchUpdate?

    func update(state: ListViewState, oldState: ListViewState?) {
        self.stateUpdated = true
    }

    func update(list: [TestObject], batch: BatchUpdate?) {
        self.listUpdated = true
        self.list = list
        self.batch = batch
    }
}
