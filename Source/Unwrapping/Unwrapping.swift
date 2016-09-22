//
//  Unwrapping.swift
//  Created by Vadim Pavlov on 5/11/16.

import Foundation

infix operator !!
infix operator !?

public func !! <T>(wrapped: T?, failureText: @autoclosure ()->String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}


public func !? <T: ExpressibleByIntegerLiteral>(wrapped: T?, failureText: @autoclosure ()->String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}

public func !? <T: ExpressibleByStringLiteral>(wrapped: T?, failureText: @autoclosure ()->String) ->T {
    assert(wrapped != nil, failureText)
    return wrapped ?? ""
}

public func !? <T: ExpressibleByArrayLiteral>(wrapped: T?, failureText: @autoclosure ()->String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? []
}

public func !?<T>(wrapped: T?, nilDefault: @autoclosure () -> (value: T, text: String)) -> T {
    assert(wrapped != nil, nilDefault().text)
    return wrapped ?? nilDefault().value
}

public func !?(wrapped: ()?, failureText: @autoclosure ()->String) {
    assert(wrapped != nil, failureText)
}
  
