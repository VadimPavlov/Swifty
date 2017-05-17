//
//  SortDescriptor.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public typealias SortDescriptor<A> = (A, A) -> Bool

public func sortDescriptor<Value>(property: @escaping (Value) -> String, comparator: @escaping (String) -> (String) -> ComparisonResult) -> SortDescriptor<Value> {
    return { value1, value2 in
        comparator(property(value1))(property(value2)) == .orderedAscending
    }
}

public func sortDescriptor<Value, Property>(property: @escaping (Value) -> Property) -> SortDescriptor<Value> where Property: Comparable {
    return { value1, value2 in property(value1) < property(value2) }
}

public func combine<A>(sortDescriptors: [SortDescriptor<A>]) -> SortDescriptor<A> {
    return { value1, value2 in
        for descriptor in sortDescriptors {
            if descriptor(value1, value2) { return true }
            if descriptor(value2, value1) { return false }
        }
        return false
    }
}
