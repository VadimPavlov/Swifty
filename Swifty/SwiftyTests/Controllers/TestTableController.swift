//
//  TestTableController.swift
//  SwiftyTests
//
//  Created by Vadym Pavlov on 02.04.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
import UIKit
@testable import Swifty

final class TestTableController: XCTestCase {

    var tableView: MockTableView!

    override func setUp() {
        super.setUp()

        let tableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let root = UIApplication.shared.keyWindow?.rootViewController
        root?.view.addSubview(tableView)
        self.tableView = tableView
    }

    override func tearDown() {
        super.tearDown()
        tableView.removeFromSuperview()
        tableView = nil
    }

    // MARK: - Registration

    func testRegisterClass() {

        let expect = expectation(description: "Class registered")
        let controller = TableController<String, TestTableCell>(tableView: self.tableView, register: .cls) { cell, object in
            XCTAssertNil(cell.outletLabel)
            cell.textLabel?.text = object
            expect.fulfill()
        }

        controller.update(provider: ["test"])

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        XCTAssertTrue(tableView.registeredClass == TestTableCell.self)
    }

    func testRegisteredNib() {
        let expect = expectation(description: "Nib registered")
        let controller = TableController<String, TestTableCell>(tableView: self.tableView, register: .nib) { cell, object in
            XCTAssertNotNil(cell.outletLabel)
            cell.outletLabel.text = object
            expect.fulfill()
        }

        controller.update(provider: ["test"])

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        XCTAssertNotNil(tableView.registeredNib)
    }

    func testRegisteredNibname() {
        let expect = expectation(description: "Custom Nib registered")
        let controller = TableController<String, TestTableCell>(tableView: self.tableView, register: .nibName("TestTableAnotherCell")) { cell, object in
            XCTAssertNotNil(cell.outletLabel)
            cell.outletLabel.text = object
            expect.fulfill()
        }

        controller.update(provider: ["test"])

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        XCTAssertNotNil(tableView.registeredNib)
    }

    // MARK: - Updates

    func testUpdate() {
        let controller = TableController<String, UITableViewCell>(tableView: self.tableView) { cell, object in
            cell.textLabel?.text = object
        }

        XCTAssertTrue(tableView.dataSource === controller)
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)

        controller.update(provider: ["one", "two", "three"])
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 3)
    }

    func testBatch() {
        let controller = TableController<String, TestTableCell>(tableView: self.tableView, register: .nib) { cell, object in
            cell.outletLabel.text = object
        }

        let ip0 = IndexPath(item: 0, section: 0)
        let ip1 = IndexPath(item: 1, section: 0)
        let ip2 = IndexPath(item: 2, section: 0)

        let update = BatchUpdate(insertRows: [ip0, ip1, ip2])
        controller.update(provider: ["0", "1", "2"], batch: update)

        XCTAssertEqual(self.tableView.numberOfSections, 1)
        XCTAssertEqual(self.tableView.numberOfRows(inSection: 0), 3)
    }

}

