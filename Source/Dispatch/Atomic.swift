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
    private let queue = DispatchQueue(label: "atomic." + String(describing: A.self).lowercased(), attributes: .concurrent)

    public init(_ value: A) {
        _value = value
    }
    
    public var value: A {
        get { return queue.sync { _value } }
        set { queue.async(flags: .barrier) { self._value = newValue } }
    }

    public func mutate(sync: Bool = true, block: @escaping (inout A) -> Void) {
        if sync {
            queue.sync(flags: .barrier) { block(&self._value) }
        } else {
            queue.async(flags: .barrier) { block(&self._value) }
        }
    }
}
