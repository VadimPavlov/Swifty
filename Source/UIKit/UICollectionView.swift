//
//  UICollectionView.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func itemWidthThatFits(count: CGFloat) -> CGFloat {
        let inset = contentInset.left + contentInset.right
        
        let width: CGFloat
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionInset = flow.sectionInset.left + flow.sectionInset.right
            let spacing = flow.minimumInteritemSpacing * (count - 1)
            width = frame.width - inset - sectionInset - spacing
            
        } else {
            width = frame.width - inset
        }
        
        return floor(width / count)
    }

    func itemHeightThatFits(count: CGFloat) -> CGFloat {
        let inset = contentInset.top + contentInset.bottom

        let height: CGFloat
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionInset = flow.sectionInset.top + flow.sectionInset.bottom
            let spacing = flow.minimumLineSpacing * (count - 1)
            height = frame.height - inset - sectionInset - spacing

        } else {
            height = frame.height - inset
        }

        return floor(height / count)
    }

    func itemSizeThatFits(count: CGFloat) -> CGSize {
        let width = self.itemWidthThatFits(count: count)
        let height = self.itemHeightThatFits(count: count)
        return CGSize(width: width, height: height)
    }
}
