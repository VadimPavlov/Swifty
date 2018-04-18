//
//  TestObservable.swift
//  SwiftyTests
//
//  Created by Vadym Pavlov on 01.02.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
@testable import Swifty

class TestObservable: XCTestCase {

    func testOldValue() {
        let property = Observable("Initial")

        var newValue: String?
        var oldValue: String?
        let disposable = property.observeOld { new, old in
            newValue = new
            oldValue = old
        }
        property.value = "Updated"

        XCTAssertEqual(newValue, "Updated")
        XCTAssertEqual(oldValue, "Initial")
        print(disposable)
    }

    func testDispose() {
        let property = Observable("Initial")
        var disposable: Disposable?

        var count = 0
        disposable = property.observe { value in
            count += 1
        }
        XCTAssertEqual(count, 1)

        property.value = "Updated"
        XCTAssertEqual(count, 2)

        disposable = nil
        property.value = "Ignored"
        XCTAssertEqual(count, 2)
        print(disposable ?? "")

    }

}
