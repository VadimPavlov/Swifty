//
//  Foundation.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import CoreGraphics

public extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
