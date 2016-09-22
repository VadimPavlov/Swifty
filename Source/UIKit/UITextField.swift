//
//  String.swift
//  Created by Vadim Pavlov on 26.07.16.

import UIKit

public extension UITextField {
	func setPlaceholderColor(_ color: UIColor) {
		if let placeholder = self.placeholder {
			self.attributedPlaceholder = placeholder.foregroundColorString(color)
		}
	}
}
