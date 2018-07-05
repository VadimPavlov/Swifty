//
//  Observable.swift
//  Swifty
//
//  Created by Vadym Pavlov on 31.01.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

final public class Observable<Value> {

    public typealias Observer    = (Value) -> Void
    public typealias ObserverOld = (Value, Value) -> Void

    private var observers:    Atomic<[UUID: Observer]>
    private var observersOld: Atomic<[UUID: ObserverOld]>

    public init(_ value: Value) {
        self.value = value
        self.observers    = Atomic([:])
        self.observersOld = Atomic([:])
    }

    public var value: Value {
        didSet {
            observers.value.forEach { (_, observer) in
                observer(self.value)
            }
            observersOld.value.forEach { (_, observer) in
                observer(self.value, oldValue)
            }
        }
    }

    public func observe(onlyNew: Bool = false, observer: @escaping Observer) -> Disposable {
        if !onlyNew {
            observer(self.value)
        }

        let id = UUID()
        self.observers.mutate { observers in
            observers[id] = observer
        }

        return Disposable {
            self.observers.mutate { observers in
                observers[id] = nil
            }
        }
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
