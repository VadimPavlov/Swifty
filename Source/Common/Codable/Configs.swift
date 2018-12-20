//
//  Configs.swift
//  Swifty
//
//  Created by Vadim Pavlov on 12/20/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

public typealias JSONDecoderConfig = (JSONDecoder) -> Void
public func decoded<Object: Decodable>(data: Data, config: JSONDecoderConfig? = nil) -> Future<Object> {
    do {
        let decoder = JSONDecoder()
        config?(decoder)
        let object = try decoder.decode(Object.self, from: data)
        return Future.success(object)
    } catch {
        return Future.error(error)
    }
}

public typealias JSONEncoderConfig = (JSONEncoder) -> Void
public func encoded<Object: Encodable>(object: Object, config: JSONEncoderConfig? = nil) -> Future<Data> {
    do {
        let encoder = JSONEncoder()
        config?(encoder)
        let data = try encoder.encode(object)
        return Future.success(data)
    } catch {
        return Future.error(error)
    }
}
