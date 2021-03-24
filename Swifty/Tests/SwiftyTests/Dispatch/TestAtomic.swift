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

    func testRead() {
        let count = 10_000
        let array = Array(repeating: "test", count: count)
        let atomic = Atomic(array)
        DispatchQueue.concurrentPerform(iterations: count) { index in
            let value = atomic.value[index]
            XCTAssertNotNil(value) // assert not crash
        }
    }

    func testMutateSync() {
        let atomicArray = Atomic<[Int]>([])
        let iterations = 10_000
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            atomicArray.mutate { array in
                let last = array.last ?? 0
                array.append(last + 1)
            }
        }

        XCTAssertEqual(atomicArray.value.count, iterations)
    }

    func testMutateAsync() {
        let atomicArray = Atomic<[Int]>([])
        let iterations = 10_000
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            atomicArray.mutate(sync: false) { array in
                let last = array.last ?? 0
                array.append(last + 1)
            }
        }

        XCTAssertEqual(atomicArray.value.count, iterations)
    }
}
