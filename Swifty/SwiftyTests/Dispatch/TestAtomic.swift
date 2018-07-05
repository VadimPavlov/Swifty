//
//  TestAtomic.swift
//  SwiftyTests
//
//  Created by Vadym Pavlov on 04.07.2018.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
@testable import Swifty

class TestAtomic: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerform() {
        let array = Atomic<[Int]>([])
        let iterations = 10_000
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            array.perform { safeArray in
                let last = safeArray.last ?? 0
                safeArray.append(last + 1)
            }
        }

        XCTAssertEqual(array.value.count, iterations)
    }


}
