//
//  Unwrapping.swift
//  SwiftCourse
//
//  Created by Vadim Pavlov on 5/11/16.
//  Copyright © 2016 DataArt. All rights reserved.
//

import Foundation

infix operator !! { }
infix operator !? { }

func !! <T>(wrapped: T?, @autoclosure failureText: ()->String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}


func !? <T: IntegerLiteralConvertible>(wrapped: T?, @autoclosure failureText: ()->String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}

func !? <T: StringLiteralConvertible>(wrapped: T?, @autoclosure failureText: ()->String) ->T {
    assert(wrapped != nil, failureText)
    return wrapped ?? ""
}

func !? <T: ArrayLiteralConvertible>(wrapped: T?, @autoclosure failureText: ()->String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? []
}

func !?<T>(wrapped: T?, @autoclosure nilDefault: () -> (value: T, text: String)) -> T {
    assert(wrapped != nil, nilDefault().text)
    return wrapped ?? nilDefault().value
}

func !?(wrapped: ()?, @autoclosure failureText: ()->String) {
    assert(wrapped != nil, failureText)
}
  