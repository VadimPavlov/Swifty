//
//  UIImage.swift
//  Swifty
//
//  Created by Vadym Pavlov on 10.03.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

public extension UIImage {
    func image(with color: UIColor) -> UIImage {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()

        image.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result.withRenderingMode(.alwaysOriginal)
    }
}

