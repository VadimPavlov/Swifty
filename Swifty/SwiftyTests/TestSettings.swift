//
//  TestSettings.swift
//  SwiftyTests
//
//  Created by Vadim Pavlov on 4/12/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest
@testable import Swifty

enum TestKeys: String, SettingKey {
    case string
    case data

    case integer
    case float
    case double
    case number

    case intEnum
    case stringEnum

    case object

    static var allKeys: [TestKeys] = [.string, .data, .integer, .float, .double, .number, .intEnum, .stringEnum, .object]
}

class TestSettings: Settings<TestKeys> {
}

class SettingsTests: XCTestCase {

    var settings: TestSettings!

    override func setUp() {
        super.setUp()

        let defaults = UserDefaults()
        settings = TestSettings(defaults: defaults)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        settings.clearAll()
        settings = nil
    }

    func testClear() {
        settings[.string] = "test"
        settings[.integer] = 123

        let string: String? = settings[.string]
        let integer: Int? = settings[.integer]

        XCTAssertEqual(string, "test")
        XCTAssertEqual(integer, 123)

        settings.clearAll()

        let clearedString: String? = settings[.string]
        let clearedInteger: Int? = settings[.integer]
        XCTAssertNil(clearedString)
        XCTAssertNil(clearedInteger)

    }

    func testStrings() {

        let stringValue: String = "test"
        settings[.string] = stringValue

        let string: String? = settings[.string]
        let nsstring: NSString? = settings[.string]

        XCTAssertEqual(string, stringValue)
        XCTAssertEqual(nsstring, stringValue as NSString)
    }

    func testNumbers() {

        // integer
        let intValue: Int = 1
        settings[.integer] = intValue

        let int: Int? = settings[.integer]
        let intNumber: NSNumber? = settings[.integer]

        XCTAssertEqual(int, intValue)
        XCTAssertEqual(intNumber?.intValue, intValue)


        // float
        let floatValue: Float = 1.2
        settings[.float] = floatValue

        let float: Float? = settings[.float]
        let floatNumber: NSNumber? = settings[.float]

        XCTAssertEqual(float, floatValue)
        XCTAssertEqual(floatNumber?.floatValue, floatValue)

        // double
        let doubleValue: Double = 1.23
        settings[.double] = doubleValue

        let double: Double? = settings[.double]
        let doubleNumber: NSNumber? = settings[.double]

        XCTAssertEqual(double, doubleValue)
        XCTAssertEqual(doubleNumber?.doubleValue, doubleValue)

        // number
        let numberValue: NSNumber = 123
        settings[.number] = numberValue

        let number: NSNumber? = settings[.number]
        XCTAssertEqual(number, 123)
    }

    func testEnums() {

        // Int
        enum IntegerEnum: Int {
            case zero
            case one
        }

        let intValue = IntegerEnum.one
        settings[.intEnum] = intValue

        let int: IntegerEnum? = settings[.intEnum]
        XCTAssertEqual(int, intValue)


        // String
        enum StringEnum: String {
            case first
            case second
        }

        let stringValue = StringEnum.second

        settings[.stringEnum] = stringValue

        let string: StringEnum? = settings[.stringEnum]
        XCTAssertEqual(string, stringValue)

    }

    /*
    func testCodable() {

        struct TestObject: Codable {
            let id: Int
            let name: String
        }

        let value = TestObject(id: 1, name: "test")

        settings[.object] = value

        let object: TestObject? = settings[.object]

        XCTAssertEqual(object?.id, value.id)
        XCTAssertEqual(object?.name, value.name)

    }
     */

}
