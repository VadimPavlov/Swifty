//
//  MockCollectionView.swift
//  SwiftyTests
//
//  Created by Vadim Pavlov on 8/9/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

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
