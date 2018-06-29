//
//  Dispatch.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public func after(_ interval: TimeInterval, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: block)
}
