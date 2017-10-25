//
//  String.swift
//  Created by Vadim Pavlov on 26.07.16.

import UIKit

public extension String {
	func foregroundColorString(color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: [.foregroundColor : color])
	}
    
    func asHTML(font: UIFont? = nil, color: UIColor? = nil) -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        
        let type = NSAttributedString.DocumentType.html
        let encoding = String.Encoding.utf8.rawValue
        let html = try? NSAttributedString(data: data,
                                            options: [.documentType: type, .characterEncoding: encoding],
                                            documentAttributes: nil)
        
        guard let htmlString = html else { return nil }
        
        let result = NSMutableAttributedString(attributedString: htmlString)
        let range = NSRange(location: 0, length: result.length)
        
        if let font = font {
            result.addAttribute(.font, value: font, range: range)
        }
        if let color = color {
            result.addAttribute(.foregroundColor, value: color, range: range)
        }
        return result
    }
}
