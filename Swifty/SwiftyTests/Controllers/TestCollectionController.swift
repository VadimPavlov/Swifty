//
//  TestCollectionController.swift
//  SwiftyTests
//
//  Created by Vadim Pavlov on 8/9/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
import UIKit
@testable import Example
@testable import Swifty

class TestCollectionController: XCTestCase {

    var collectionView: MockCollectionView!

    override func setUp() {
        super.setUp()
        let collectionView = MockCollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: UICollectionViewFlowLayout())
        let root = UIApplication.shared.keyWindow?.rootViewController
        root?.view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        collectionView.removeFromSuperview()
        collectionView = nil
    }

    // MARK: - Registration

    func testRegisterCellClass() {

        let expect = expectation(description: "Class registered")
        let controller = CollectionController<String, TestCollectionCell>(collectionView: self.collectionView, register: .cls) { cell, object in
            XCTAssertNil(cell.outletLabel)
            expect.fulfill()
        }

        controller.update(provider: ["test"])

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        XCTAssertTrue(collectionView.registeredCellClass == TestCollectionCell.self)
    }

    func testRegisteredCellNib() {
        let expect = expectation(description: "Nib registered")
        let controller = CollectionController<String, TestCollectionCell>(collectionView: self.collectionView, register: .nib) { cell, object in
            XCTAssertNotNil(cell.outletLabel)
            cell.outletLabel.text = object
            expect.fulfill()
        }

        controller.update(provider: ["test"])

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        XCTAssertNotNil(collectionView.registeredCellNib)
    }

    func testRegisteredCellNibname() {
        let expect = expectation(description: "Custom Nib registered")
        let controller = CollectionController<String, TestCollectionCell>(collectionView: self.collectionView, register: .nibName("TestCollectionAnotherCell")) { cell, object in
            XCTAssertNotNil(cell.outletLabel)
            cell.outletLabel.text = object
            expect.fulfill()
        }

        controller.update(provider: ["test"])

        waitForExpectations(timeout: 1) { error in
            XCTAssertNil(error)
        }
        XCTAssertNotNil(collectionView.registeredCellNib)
    }


    // MARK: - Updates

    func testUpdate() {
        let controller = CollectionController<UIColor, UICollectionViewCell>(collectionView: self.collectionView) { cell, color in
            cell.contentView.backgroundColor = color
        }

        XCTAssertTrue(collectionView.dataSource === controller)
        XCTAssertEqual(collectionView.numberOfSections, 1)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 0)

        controller.update(provider: [UIColor.cyan, UIColor.magenta, UIColor.yellow])
        XCTAssertEqual(collectionView.numberOfSections, 1)
        XCTAssertEqual(collectionView.numberOfItems(inSection: 0), 3)
    }

    func testBatch() {

        let controller = CollectionController<String, TestCollectionCell>(collectionView: self.collectionView, register: .nib) { cell, object in
            cell.outletLabel.text = object
        }

        let ip0 = IndexPath(item: 0, section: 0)
        let ip1 = IndexPath(item: 1, section: 0)
        let ip2 = IndexPath(item: 2, section: 0)

        let update = BatchUpdate(insertRows: [ip0, ip1, ip2])
        controller.update(provider: ["0", "1", "2"], batch: update)

        XCTAssertEqual(self.collectionView.numberOfSections, 1)
        XCTAssertEqual(self.collectionView.numberOfItems(inSection: 0), 3)
    }
}
