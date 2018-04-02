//
//  MockTableView.swift
//  SwiftyTests
//
//  Created by Vadym Pavlov on 03.04.18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

class MockTableView: UITableView {
    var registeredNib: UINib?
    var registeredClass: AnyClass?

    override func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        self.registeredNib = nib
        super.register(nib, forCellReuseIdentifier: identifier)
    }

    override func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        self.registeredClass = cellClass
        super.register(cellClass, forCellReuseIdentifier: identifier)
    }
}
