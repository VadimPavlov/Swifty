//
//  RoundedButton.swift
//  Created by Vadim Pavlov on 4/12/16.

import UIKit

@IBDesignable
open class UIRoundedView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable open var borderColor : UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable open var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable
open class UIRoundedImageView: UIImageView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBInspectable open var borderColor : UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable open var borderWidth : CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var cornerRadius : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable
open class UIRoundedButton: UIButton {
    
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable open var borderColor : UIColor = UIColor.clear {
		didSet {
			self.layer.borderColor = borderColor.cgColor
		}
	}
	
	@IBInspectable open var borderWidth : CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = borderWidth
		}
	}
	
	@IBInspectable open var cornerRadius : CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = cornerRadius
		}
	}
}

@IBDesignable
open class UIRoundedTextField: UITextField {
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@IBInspectable open var borderColor : UIColor = UIColor.clear {
		didSet {
			self.layer.borderColor = borderColor.cgColor
		}
	}
	
	@IBInspectable open var borderWidth : CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = borderWidth
		}
	}
	
	@IBInspectable open var cornerRadius : CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = cornerRadius
		}
	}
}
