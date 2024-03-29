//
//  LossyArray.swift
//  Swifty
//
//  Created by Vadym Pavlov on 09.06.2018.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

struct AnyCodable: Codable {}

public struct LossyArray<Element: Decodable>: Decodable, ExpressibleByArrayLiteral {

    public let array: [Element]
    
    public init(arrayLiteral elements: Element...) {
        array = elements
    }
    
    public init(_ array: [Element]) {
        self.array = array
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: [Element] = []
        while !container.isAtEnd {
            do {
                let item = try container.decode(Element.self)
                elements.append(item)
            } catch {
                print("[LossyArray]: \(error)")
                // increment currentIndex of container, prevent infinit loop
                let _ = try? container.decode(AnyCodable.self)
            }
        }
        self.array = elements
    }
}
