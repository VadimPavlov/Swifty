//
//  Throttle.swift
//  Swifty
//
//  Created by Vadim Pavlov on 7/10/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

@available(iOS 10.0, OSX 10.12, *)
public final class Throttle {

    public let delay: TimeInterval
    public init(delay: TimeInterval) {
        self.delay = delay
    }

    deinit {
        timer?.invalidate()
    }

    var timer: Timer? {
        didSet {
            oldValue?.invalidate()
        }
    }

    public func perform(block: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            block()
        }
    }
}
