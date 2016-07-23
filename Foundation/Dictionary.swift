//
//  Collection.swift
//  SwiftCourse
//
//  Created by Vadim Pavlov on 4/27/16.
//  Copyright © 2016 DataArt. All rights reserved.
//

import Foundation

extension CollectionType {
    func find(@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Self.Generator.Element? {
        return try indexOf(predicate).map({self[$0]})
    }
}

extension Dictionary {
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
    func mapPairs<OutKey: Hashable, OutValue>(@noescape transform: Element throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
        return Dictionary<OutKey, OutValue>(try map(transform))
    }
    
    func filterPairs(@noescape includeElement: Element throws -> Bool) rethrows -> [Key: Value] {
        return Dictionary(try filter(includeElement))
    }
}