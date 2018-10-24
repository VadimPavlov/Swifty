//
//  MetaArray.swift
//  Swifty
//
//  Created by Vadym Pavlov on 10/24/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

public protocol Meta: Codable {
    associatedtype Element
    static func metatype(for element: Element) -> Self
    var type: Decodable.Type { get }

    init?(rawValue: String)
    var rawValue: String { get }
}

public struct MetaArray<M: Meta>: Codable, ExpressibleByArrayLiteral {

    public let array: [M.Element]

    public init(_ array: [M.Element]) {
        self.array = array
    }

    public init(arrayLiteral elements: M.Element...) {
        self.array = elements
    }

    struct ElementKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var elements: [M.Element] = []
        while !container.isAtEnd {
            let nested = try container.nestedContainer(keyedBy: ElementKey.self)
            guard let key = nested.allKeys.first else { continue }
            let metatype = M(rawValue: key.stringValue)
            let superDecoder = try nested.superDecoder(forKey: key)
            let object = try metatype?.type.init(from: superDecoder)
            if let element = object as? M.Element {
                elements.append(element)
            }
        }
        array = elements
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try array.forEach { object in
            var nested = container.nestedContainer(keyedBy: ElementKey.self)
            let metatype = M.metatype(for: object)
            if let key = ElementKey(stringValue: metatype.rawValue) {
                let superEncoder = nested.superEncoder(forKey: key)
                let encodable = object as? Encodable
                try encodable?.encode(to: superEncoder)
            }
        }
    }
}
