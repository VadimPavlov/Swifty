//
//  LocalizedString.swift
//  SwiftyIOS
//
//  Created by Vadim Pavlov on 12/19/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

public enum LocalizedString {

    public static var no: String { return string(for: .no) }
    public static var yes: String { return string(for: .yes) }

    public static var ok: String { return string(for: .ok) }
    public static var cancel: String { return string(for: .cancel) }
    public static var save: String { return string(for: .save) }
    public static var delete: String { return string(for: .delete) }

    // MARK: - Plurals
    public static func items(_ count: Int) -> String {
        let items = string(for: .items)
        return String(format: items, count)
    }

    public static func copies(_ count: Int) -> String {
        let copies = string(for: .copies)
        return String(format: copies, count)
    }
}

private extension LocalizedString {

    static let bundle = Bundle(for: UIApplication.self)

    enum Keys: String {
        case yes
        case no

        case ok
        case cancel
        case save
        case delete

        // plurals
        case items
        case copies
    }

    static func string(for key: Keys) -> String {
        return bundle.localizedString(forKey: key.rawValue.capitalized, value: nil, table: nil)
    }

}

