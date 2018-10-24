//
//  String.swift
//  Created by Vadim Pavlov on 26.07.16.

#if canImport(UIKit)
import UIKit
public typealias Color = UIColor
public typealias Font = UIFont
#endif

#if canImport(AppKit)
import AppKit
public typealias Color = NSColor
public typealias Font = NSFont
#endif

public extension String {
	func foregroundColorString(color: Color) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: [.foregroundColor : color])
	}
    
    func asHTML(font: Font? = nil, color: Color? = nil) -> NSAttributedString? {
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
