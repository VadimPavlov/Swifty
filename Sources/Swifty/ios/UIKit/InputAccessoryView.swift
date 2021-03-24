//
//  InputAccessoryView.swift
//  SwiftyIOS
//
//  Created by Vadim Pavlov on 11/15/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

final public class InputAccesoryView: UIView {
    override public func didMoveToWindow() {
        super.didMoveToWindow()

        // Fix for iPhones with bottom safe area
        if #available(iOS 11.0, *) {
            if let window = self.window, window.safeAreaInsets.bottom > 0 {
                let anchor = window.safeAreaLayoutGuide.bottomAnchor
                let constraint = bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: anchor, multiplier: 1)
                constraint.isActive = true
            }
        }
    }
}
