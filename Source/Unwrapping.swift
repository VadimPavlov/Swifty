//
//  Unwrapping.swift
//  Created by Vadim Pavlov on 5/11/16.

import Foundation

infix operator !! { }
infix operator !? { }

public func !! <T>(wrapped: T?, @autoclosure failureText: ()->String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}


public func !? <T: IntegerLiteralConvertible>(wrapped: T?, @autoclosure failureText: ()->String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}

public func !? <T: StringLiteralConvertible>(wrapped: T?, @autoclosure failureText: ()->String) ->T {
    assert(wrapped != nil, failureText)
    return wrapped ?? ""
}

public func !? <T: ArrayLiteralConvertible>(wrapped: T?, @autoclosure failureText: ()->String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? []
}

public func !?<T>(wrapped: T?, @autoclosure nilDefault: () -> (value: T, text: String)) -> T {
    assert(wrapped != nil, nilDefault().text)
    return wrapped ?? nilDefault().value
}

public func !?(wrapped: ()?, @autoclosure failureText: ()->String) {
    assert(wrapped != nil, failureText)
}
  