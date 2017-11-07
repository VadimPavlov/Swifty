//
//  CollectionItemRegistration.swift
//  Swifty
//
//  Created by Vadym Pavlov on 03.11.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public protocol AnyCell {}
extension UITableViewCell: AnyCell {}
extension UICollectionViewCell: AnyCell {}


public enum CollectionItemRegistration {
    case cls // class name
    case nib // nib name from class name
    case nibName(String)
}
