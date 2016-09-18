//
//  UIGradientView.swift
//  Created by Vadim Pavlov on 19.12.15.

import UIKit

@IBDesignable class UIGradientView: UIView {
    @IBInspectable var startColor: UIColor = UIColor.blackColor() {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.updateColors()
        }
    }
    
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        willSet {
            self.gradientLayer.startPoint = newValue
        }
    }
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        willSet {
            self.gradientLayer.endPoint = newValue
        }
    }

    // initialization
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateColors()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateColors()
    }
    
    // private
    private func updateColors() {
        self.gradientLayer.colors = [self.startColor.CGColor, self.endColor.CGColor]
        self.setNeedsDisplay()
    }

    
    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
}