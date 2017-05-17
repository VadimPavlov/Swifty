//
//  Atomic.swift
//  Swifty
//
//  Created by Vadym Pavlov on 15.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

class Atomic<A> {
    private var _value: A
    private let queue = DispatchQueue(label: "Serial " + String(describing: A.self))
    init(value: A) {
        _value = value
    }
    
    var value: A {
        get {
            return queue.sync { _value }
        }
        set {
            queue.sync { _value = newValue }
        }
    }
    
}
