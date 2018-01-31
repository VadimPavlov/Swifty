//
//  Atomic.swift
//  Swifty
//
//  Created by Vadym Pavlov on 15.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public class Atomic<A> {
    private var _value: A
    private let queue = DispatchQueue(label: "serial." + String(describing: A.self).lowercased())

    public init(_ value: A) {
        _value = value
    }
    
    public var value: A {
        get {
            return queue.sync { _value }
        }
        set {
            queue.sync { _value = newValue }
        }
    }

    public func perform(block: (inout A) -> Void) {
        queue.sync {
            block(&_value)
        }
    }
}
