//
//  RoundedButton.swift
//  Created by Vadim Pavlov on 4/12/16.

import UIKit

@IBDesignable
public class UIRoundedButton: UIButton {
    
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable public var borderColor : UIColor = UIColor.clearColor() {
		didSet {
			self.layer.borderColor = borderColor.CGColor
		}
	}
	
	@IBInspectable public var borderWidth : CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = borderWidth
		}
	}
	
	@IBInspectable public var cornerRadius : CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = cornerRadius
		}
	}
}

@IBDesignable
public class UIRoundedView: UIView {
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable public var borderColor : UIColor = UIColor.clearColor() {
		didSet {
			self.layer.borderColor = borderColor.CGColor
		}
	}
	
	@IBInspectable public var borderWidth : CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = borderWidth
		}
	}
	
	@IBInspectable public var cornerRadius : CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = cornerRadius
		}
	}
}
@IBDesignable
public class UIRoundedTextField: UITextField {
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable public var borderColor : UIColor = UIColor.clearColor() {
		didSet {
			self.layer.borderColor = borderColor.CGColor
		}
	}
	
	@IBInspectable public var borderWidth : CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = borderWidth
		}
	}
	
	@IBInspectable public var cornerRadius : CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = cornerRadius
		}
	}
}
