//
//  HeaderFooterDescriptor.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.07.2018.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

public struct HeaderFooterDescriptor<View: UITableViewHeaderFooterView> {
    public let identifier: String
    public let register: Register?

    public init(identifier: String? = nil, register: Register? = nil) {
        self.identifier = identifier ?? String(describing: View.self)
        self.register = register
    }
}
