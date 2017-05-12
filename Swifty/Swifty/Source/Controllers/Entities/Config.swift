//
//  UIView.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public struct Config <Cell, Object> {
    
    public enum Register {
        case cellClass(AnyClass)
        case nibName(String)
    }
    
    public let identifier: String
    public let register: Register?
    
    public typealias Setup = (Cell, Object) -> Void
    public let setup: Setup
    
    public init(identifier: String? = nil, register: Register? = nil, setup: @escaping Setup) {
        self.identifier = identifier ?? String(describing: Cell.self)
        self.register = register
        self.setup = setup
    }
}
