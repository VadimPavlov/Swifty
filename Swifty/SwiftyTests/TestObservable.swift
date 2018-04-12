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

    }

}
