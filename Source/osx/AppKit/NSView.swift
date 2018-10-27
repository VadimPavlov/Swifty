//
//  NSView.swift
//  SwiftyIOS
//
//  Created by Vadym Pavlov on 10/27/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import AppKit

extension NSView {
    var center: NSPoint {
        get { return NSPoint(x: self.frame.midX, y: self.frame.midY) }
        set {
            let x = newValue.x - self.frame.midX
            let y = newValue.y - self.frame.midY
            self.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
}
