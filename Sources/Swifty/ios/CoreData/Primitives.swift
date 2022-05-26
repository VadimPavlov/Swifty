//
//  Primitives.swift
//  Swifty
//
//  Created by Vadim Pavlov on 10/20/17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import CoreData

public protocol Primitives: AnyObject {
    associatedtype PrimitiveKey: RawRepresentable
}

public extension Primitives where Self: NSManagedObject, PrimitiveKey.RawValue == String {

    subscript<O>(key: PrimitiveKey) -> O? {
        set {
            let primitiveKey = key.rawValue
            let primitiveValue = newValue
            self.willChangeValue(forKey: primitiveKey)
            if let value = primitiveValue {
                self.setPrimitiveValue(value, forKey: primitiveKey)
            } else {
                self.setPrimitiveValue(nil, forKey: primitiveKey)
            }
            self.didChangeValue(forKey: primitiveKey)
        }
        get {
            let primitiveKey = key.rawValue
            self.willAccessValue(forKey: primitiveKey)
            let primitiveValue = self.primitiveValue(forKey: primitiveKey) as? O
            self.didAccessValue(forKey: primitiveKey)
            return primitiveValue
        }
    }

    subscript<P: RawRepresentable>(key: PrimitiveKey) -> P? {
        set {
            let primitiveKey = key.rawValue
            let primitiveValue = newValue?.rawValue
            self.willChangeValue(forKey: primitiveKey)
            self.setPrimitiveValue(primitiveValue, forKey: primitiveKey)
            self.didChangeValue(forKey: primitiveKey)
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
