//
//  Array.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    
    mutating func remove(_ objects: [Element]) {
        for object in objects {
            if let index = index(of: object) {
                remove(at: index)
            }
        }
    }
    
}
