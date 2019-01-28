//
//  Observable.swift
//  Swifty
//
//  Created by Vadym Pavlov on 31.01.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

final public class Observable<Value>: Listenable<Value> {

    public typealias Observer = Listener
    public typealias ObserverOld = (Value, Value) -> Void

    private var observersOld: Atomic<[UUID: ObserverOld]>

    public init(_ value: Value) {
        self.value = value
        self.observersOld = Atomic([:])
        super.init()
    }

    public var value: Value {
        didSet {
            write(value: self.value)
            observersOld.value.forEach { (_, observer) in
                observer(self.value, oldValue)
            }
        }
    }

    public func observe(onlyNew: Bool = false, observer: @escaping Observer) -> Disposable {
        if !onlyNew { observer(self.value) }
        return self.listen(listener: observer)
    }

    public func observeOld(observer: @escaping ObserverOld) -> Disposable {

        let id = UUID()
        self.observersOld.mutate { observers in
            observers[id] = observer
        }

        return Disposable {
            self.observersOld.mutate { observers in
                observers[id] = nil
            }
        }
    }
}

extension Observable where Value: Equatable {

    public func distinct(onlyNew: Bool = false, observer: @escaping Observer) -> Disposable {
        if !onlyNew { observer(self.value) }

        return self.observeOld { newValue, oldValue in
            if newValue != oldValue {
                observer(newValue)
            }
        }
    }
}
