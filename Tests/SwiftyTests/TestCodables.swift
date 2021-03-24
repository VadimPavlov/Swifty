//
//  TestCodables.swift
//  SwiftyIOSTests
//
//  Created by Vadim Pavlov on 12/3/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
@testable import Swifty

class TestCodables: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodeStrint() {

        let string = """
        { "id": "5" }
        """

        let integer = """
        { "id": 3}
        """

        let invalid = """
        { "id": null}
        """

        let decoder = JSONDecoder()
        let stringData = string.data(using: .utf8)!
        let integerData = integer.data(using: .utf8)!
        let invalidData = invalid.data(using: .utf8)!

        let stringObject = try! decoder.decode(Object.self, from: stringData)
        let integerObject = try! decoder.decode(Object.self, from: integerData)

        XCTAssertEqual(stringObject.id.intValue, 5)
        XCTAssertEqual(stringObject.id.stringValue, "5")

        XCTAssertEqual(integerObject.id.intValue, 3)
        XCTAssertEqual(integerObject.id.stringValue, "3")

        do {
            let invalidObject = try decoder.decode(Object.self, from: invalidData)
            XCTFail("\(invalidObject) should not be parsed")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testEncodeString() {
        let stringObject = Object(id: .string("5"))
        let integerObject = Object(id: .int(3))

        let encoder = JSONEncoder()
        //encoder.outputFormatting = .prettyPrinted

        let stringData = try! encoder.encode(stringObject)
        let integerData = try! encoder.encode(integerObject)

        let stringJSON = String(data: stringData, encoding: .utf8)
        let integerJSON = String(data: integerData, encoding: .utf8)

        let string = """
        {"id":"5"}
        """

        let integer = """
        {"id":3}
        """

        XCTAssertEqual(string, stringJSON)
        XCTAssertEqual(integer, integerJSON)
    }

    func testLossyArray() {

        let array = """
        [{ "id": "1" }, { "id": null }, { "id": "3" }]
        """

        let decoder = JSONDecoder()
        let arrayData = array.data(using: .utf8)!

        let objects = try! decoder.decode(LossyArray<Object>.self, from: arrayData)

        let first = objects.array.first
        let last = objects.array.last

        XCTAssertEqual(objects.array.count, 2)
        XCTAssertEqual(first?.id.intValue, 1)
        XCTAssertEqual(last?.id.intValue, 3)
    }

}

private struct Object: Codable {
    let id: Strint
}
