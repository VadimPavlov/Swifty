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

class TestTableController: XCTestCase {

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

    func testRegisterClass() {

        let expect = expectation(description: "Class registered")
        let controller = TableController<String, TestTableCell>(tableView: self.tableView, register: .cls) { cell, object in
            precondition(cell.outletLabel == nil)
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
            precondition(cell.outletLabel != nil)
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
            precondition(cell.outletLabel != nil)
            cell.outletLabel.text = object
            expect.fulfill()
        }

        controller.update(provider: ["test"])

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        XCTAssertNotNil(tableView.registeredNib)
    }

}

