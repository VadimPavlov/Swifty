//
//  Listenable.swift
//  Swifty
//
//  Created by Vadim Pavlov on 1/28/19.
//  Copyright © 2019 Vadym Pavlov. All rights reserved.
//

import Foundation

public class Listenable<Value> {
    public typealias Listener = (Value) -> Void
    private var listeners: Atomic<[UUID: Listener]>

    public init() {
        self.listeners = Atomic([:])
    }

    public func listen(listener: @escaping Listener) -> Disposable {
        let id = UUID()
        self.listeners.mutate { listeners in
            listeners[id] = listener
        }

        return Disposable {
            self.listeners.mutate { listeners in
                listeners[id] = nil
            }
        }
    }

    public func write(value: Value) {
        listeners.value.forEach { (_, listener) in
            listener(value)
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
