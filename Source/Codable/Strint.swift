//
//  Strint.swift
//  Swifty
//
//  Created by Vadym Pavlov on 10/24/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

public enum Strint: Hashable, Codable {
    case int(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .string(container.decode(String.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(Strint.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        case .string(let string):
            try container.encode(string)
        }
    }

    public var stringValue: String {
        switch self {
        case .string(let string): return string
        case .int(let int): return String(int)
        }
    }

    public var intValue: Int? {
        switch self {
        case .int(let int): return int
        case .string(let string): return Int(string)
        }
    }
}
