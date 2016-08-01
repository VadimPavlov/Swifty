//
//  IBInspectable.swift
//  Created by Vadim Pavlov on 4/12/16.

import UIKit

@IBDesignable
class IBView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable var borderColor : UIColor = UIColor.clearColor() {
		didSet { self.layer.borderColor = borderColor.CGColor }
	}
	
	@IBInspectable var borderWidth : CGFloat = 0.0 {
		didSet { self.layer.borderWidth = borderWidth }
	}
	
	@IBInspectable var cornerRadius : CGFloat = 0.0 {
		didSet { self.layer.cornerRadius = cornerRadius }
	}
}

@IBDesignable
class IBButton: UIButton {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable var borderColor : UIColor = UIColor.clearColor() {
		didSet { self.layer.borderColor = borderColor.CGColor }
	}
	
	@IBInspectable var borderWidth : CGFloat = 0.0 {
		didSet { self.layer.borderWidth = borderWidth }
	}
	
	@IBInspectable var cornerRadius : CGFloat = 0.0 {
		didSet { self.layer.cornerRadius = cornerRadius }
	}
}

@IBDesignable
class IBTextField: UITextField {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable var borderColor : UIColor = UIColor.clearColor() {
		didSet { self.layer.borderColor = borderColor.CGColor }
	}
	
	@IBInspectable var borderWidth : CGFloat = 0.0 {
		didSet { self.layer.borderWidth = borderWidth }
	}
	
	@IBInspectable var cornerRadius : CGFloat = 0.0 {
		didSet { self.layer.cornerRadius = cornerRadius }
	}
}
