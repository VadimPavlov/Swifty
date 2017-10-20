//
//  Primitives.swift
//  Swifty
//
//  Created by Vadim Pavlov on 10/20/17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import CoreData

public protocol Primitives: class {
    associatedtype PrimitiveKey: RawRepresentable
}

public extension Primitives where Self: NSManagedObject, PrimitiveKey.RawValue == String {
    subscript<P: RawRepresentable>(key: PrimitiveKey) -> P? {
        set {
            let primitiKey = key.rawValue
            let primitiveValue = newValue?.rawValue
            self.willChangeValue(forKey: primitiKey)
            self.setPrimitiveValue(primitiveValue, forKey: primitiKey)
            self.didChangeValue(forKey: primitiKey)
            
        }
        get {
            let primitiveKey = key.rawValue
            self.willAccessValue(forKey: primitiveKey)
            let primitiveValue = self.primitiveValue(forKey: primitiveKey) as? P.RawValue
            self.didAccessValue(forKey: primitiveKey)
            return primitiveValue.flatMap(P.init)
        }
    }
}
