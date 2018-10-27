//
//  BlurView.swift
//  SwiftyIOS
//
//  Created by Vadym Pavlov on 10/27/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
open class BlurView: UIVisualEffectView {

    private let blurEffect: UIBlurEffect
    private let animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: nil)

    var depth: CGFloat {
        get { return animator.fractionComplete }
        set { animator.fractionComplete = newValue }
    }

    lazy var vibranceView: UIVisualEffectView = {
        let vibranceView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        vibranceView.frame = bounds
        vibranceView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(vibranceView)
        return vibranceView
    }()

    required public init(frame: CGRect, style: UIBlurEffect.Style, depth: CGFloat) {

        self.blurEffect = UIBlurEffect(style: style)
        super.init(effect: nil)

        self.frame = frame
        self.animator.addAnimations { [unowned self] in self.effect = self.blurEffect }
        self.depth = depth
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
