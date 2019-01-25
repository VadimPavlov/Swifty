//
//  Result.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case error(Error)
    
    public func map<U>(_ transform: (Value) -> U) -> Result<U> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let value): return .success(transform(value))
        }
    }
    
    public func flatMap<U>(_ transform: (Value) -> Result<U>) -> Result<U> {
        switch self {
        case .error(let error): return .error(error)
        case .success(let value): return transform(value)
        }
    }

    public static var success: Result<Void> {
        return Result<Void>.success(())
    }

}
