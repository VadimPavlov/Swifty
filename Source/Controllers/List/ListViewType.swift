//
//  ListViewType.swift
//  Paradise
//
//  Created by Vadim Pavlov on 3/7/17.
//  Copyright © 2017 monspace. All rights reserved.
//

import Foundation

public protocol ListViewType: ViewType {
    func update(list: [ListObject], batch: BatchUpdate?, animated: Bool)
}
