//
//  ExampleTableViewController.swift
//  SwiftyIOS
//
//  Created by Vadim Pavlov on 11/6/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

final class MockTableView: UITableView {
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

final class MockCollectionView: UICollectionView {

    var registeredCellNib: UINib?
    var registeredCellClass: AnyClass?

    var registeredViewNib: UINib?
    var registeredViewClass: AnyClass?
    var registeredViewKind: String?

    override func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        registeredCellNib = nib
        super.register(nib, forCellWithReuseIdentifier: identifier)
    }

    override func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        registeredCellClass = cellClass
        super.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    override func register(_ nib: UINib?, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: String) {
        registeredViewNib = nib
        registeredViewKind = kind
    }

    override func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) {
        registeredViewClass = viewClass
        registeredViewKind = elementKind
    }
}
