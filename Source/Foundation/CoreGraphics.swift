//
//  CoreGraphics.swift
//  Swifty
//
//  Created by Vadym Pavlov on 08.10.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation
import AVFoundation

public func CGAspectSize(ratio: CGSize, inside: CGSize) -> CGSize {
    let rect = CGRect(origin: .zero, size: inside)
    return AVMakeRect(aspectRatio: ratio, insideRect: rect).size
}

public func CGAspectHeight(ratio: CGSize, width: CGFloat) -> CGFloat {
    let height = CGFloat.greatestFiniteMagnitude // CGFloat.max
    let size = CGSize(width: width, height: height)
    return ceil(CGAspectSize(ratio: ratio, inside: size).height)
}

public func CGAspectWidth(ratio: CGSize, height: CGFloat) -> CGFloat {
    let width = CGFloat.greatestFiniteMagnitude // CGFloat.max
    let size = CGSize(width: width, height: height)
    return ceil(CGAspectSize(ratio: ratio, inside: size).width)
}
