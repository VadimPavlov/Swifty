//
//  CellDescriptor.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public struct CellDescriptor {
    
    public let identifier: String
    public let register: CollectionItemRegistration?
    public let cellClass: AnyCell.Type
    public let configure: (AnyCell) -> ()
    
    public init<Cell: AnyCell>(identifier: String? = nil, register: CollectionItemRegistration? = nil, configure: @escaping (Cell) -> ()) {
        self.identifier = identifier ?? String(describing: Cell.self)
        self.register = register
        self.cellClass = Cell.self
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
}
