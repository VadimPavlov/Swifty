//
//  Array.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {

    @discardableResult
    mutating func remove(_ object: Element) -> Element? {
        if let index = index(of: object) {
            return remove(at: index)
        }
        return nil
    }
    
    mutating func remove(_ objects: [Element]) {
        objects.forEach { self.remove($0) }
    }

    func dictionary<Key: Hashable>(key: (Element) -> Key) -> [Key: Element] {
        var dictionary: [Key: Element] = [:]
        forEach { dictionary[key($0)] = $0 }
        return dictionary
    }
}
