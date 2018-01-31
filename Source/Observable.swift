//
//  Observable.swift
//  Swifty
//
//  Created by Vadym Pavlov on 31.01.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

final public class Observable<Value> {

    public typealias Observer = (Value, Value?) -> Void
    private var observers: Atomic<[UUID:Observer]>

    public init(_ value: Value) {
        self.value = value
        self.observers = Atomic([:])
    }

    public var value: Value {
        didSet {
            observers.value.forEach { (_, observer) in
                observer(self.value, oldValue)
            }
        }
    }

    public func observe(_ observer: @escaping Observer) -> Disposable {
        observer(self.value, nil)

        let id = UUID()
        self.observers.perform { observers in
            observers[id] = observer
        }

        return Disposable {
            self.observers.perform { observers in
                observers[id] = nil
            }
        }
    }
}


final public class Disposable {
    public typealias Dispose = () -> Void
    private let dispose: Dispose

    init(_ dispose: @escaping Dispose) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }
}
