//
//  UIView.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public extension UIView {
    public class func loadFromNib<View>(name: String? = nil, bundle: Bundle = .main) -> View? {
        let nibName = name ?? String(describing: self)
        let nib = bundle.loadNibNamed(nibName, owner: self, options: nil)
        return nib?.first as? View
    }
}
