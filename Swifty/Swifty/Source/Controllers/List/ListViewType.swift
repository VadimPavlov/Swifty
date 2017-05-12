//
//  ListViewType.swift
//  Created by Vadim Pavlov on 3/7/17.

import Foundation

public protocol ListViewType: ViewType {
    func update(list: [ListObject], batch: BatchUpdate?, animated: Bool)
}
