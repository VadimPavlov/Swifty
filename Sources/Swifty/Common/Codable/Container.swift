//
//  Container.swift
//  Swifty
//
//  Created by Vadim Pavlov on 7/10/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

public extension KeyedDecodingContainer {
    func decode<T: Decodable>(_ key: Key, as type: T.Type = T.self) throws -> T {
        return try self.decode(T.self, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
}
