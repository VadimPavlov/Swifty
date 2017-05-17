//
//  CellDescriptor.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public protocol AnyCell {}
extension UITableViewCell: AnyCell {}
extension UICollectionViewCell: AnyCell {}

public struct CellDescriptor {
    
    public enum Register {
        case cellClass
        case nibName(String)
    }
    
    public let identifier: String
    public let register: Register?
    public let cellClass: AnyCell.Type
    public let configure: (AnyCell) -> ()
    
    public init<Cell: AnyCell>(identifier: String? = nil, register: Register? = nil, configure: @escaping (Cell) -> ()) {
        self.identifier = identifier ?? String(describing: Cell.self)
        self.register = register
        self.cellClass = Cell.self
        self.configure = { cell in
            configure(cell as! Cell)
        }
    }
}
