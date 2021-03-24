//
//  Register.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.07.2018.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Foundation

public enum Register {
    case cls // class name
    case nib // nib name from class name
    case nibName(String)
}
