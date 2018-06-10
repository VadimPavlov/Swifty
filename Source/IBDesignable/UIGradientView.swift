//
//  UIGradientView.swift
//  Created by Vadim Pavlov on 19.12.15.

import UIKit

@IBDesignable
public class UIGradientView: UIView {
    
    @IBInspectable public var startColor: UIColor = .black {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable public var endColor: UIColor = .white {
        didSet {
            self.updateColors()
        }
    }
    
    @IBInspectable public var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        willSet {
            self.gradientLayer.startPoint = newValue
        }
    }
    @IBInspectable public var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        willSet {
            self.gradientLayer.endPoint = newValue
        }
    }

    // initialization
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateColors()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateColors()
    }
    
    // private
    private func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        self.setNeedsDisplay()
    }

    
    private var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }
}
