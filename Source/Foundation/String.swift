//
//  String.swift
//  Created by Vadim Pavlov on 26.07.16.

import UIKit

public extension String {
	func foregroundColorString(color: UIColor) -> NSAttributedString {
		return NSAttributedString(string: self, attributes: [.foregroundColor : color])
	}
    
    func asHTML() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        let attributed = try? NSAttributedString(data: data,
                                            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                            documentAttributes: nil)
        return attributed
    }
}
