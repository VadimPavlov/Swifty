//
//  ListViewState.swift
//  Created by Vadim Pavlov on 3/7/17.

import Foundation

public struct ListViewState {
    public var isEmpty: Bool?
    public var isLoading: Bool = false
    public var canLoadMore: Bool = true
    public var totalCount: Int?
}
