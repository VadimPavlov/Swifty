//
//  TestCase.swift
//  SwiftyIOSTests
//
//  Created by Vadim Pavlov on 11/6/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import XCTest

extension XCTestCase {

    func url(for resource: String, extension ext: String) -> URL? {
        let bundle = Bundle(for: type(of: self))
        return bundle.url(forResource: resource, withExtension: ext)
    }
}
