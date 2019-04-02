//
//  Collection.swift
//  Created by Vadim Pavlov on 4/27/16.

import Foundation

public extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    func mapPairs<OutKey: Hashable, OutValue>(_ transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }

    func mapKeys<OutKey: Hashable>(_ transform: @escaping (Key) -> OutKey) -> [OutKey : Value] {
        return self.mapPairs { (transform($0), $1) }
    }
    
    func mapValues<OutValue>(_ transform: (Value) -> OutValue) -> [Key : OutValue] {
        return self.mapPairs { ($0, transform($1)) }
    }

    func filterPairs(_ includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }

}

public extension Dictionary where Value: Equatable {
    func allKeys(forValue val: Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

// MARK: - Combining operators
public extension Dictionary {
    static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
    
    static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var combined = lhs
        combined += rhs
        return combined
    }
}
