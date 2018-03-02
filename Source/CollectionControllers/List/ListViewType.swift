//
//  ListViewType.swift
//  Created by Vadim Pavlov on 3/7/17.

import Foundation

public protocol ListViewType: ViewType {
    associatedtype ListViewObject
    func update(list: [ListViewObject], batch: BatchUpdate?)
}
