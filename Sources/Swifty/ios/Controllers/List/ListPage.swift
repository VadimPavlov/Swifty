//
//  ListPage.swift
//  Created by Vadim Pavlov on 3/7/17.

import Foundation

public struct ListPage {
    public let size: Int
    public let number: Int
    public var lastID: String?

    public init(size: Int, number: Int, lastID: String? = nil) {
        self.size = size
        self.number = number
        self.lastID = lastID
    }
}
