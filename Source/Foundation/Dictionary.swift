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
    
    public func mapPairs<OutKey: Hashable, OutValue>(transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
    public func filterPairs(includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }
}
