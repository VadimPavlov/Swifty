//
//  String.swift
//  Created by Vadim Pavlov on 26.07.16.

import UIKit

public extension String {
	func foregroundColorString(color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: [NSForegroundColorAttributeName : color])
	}
}
