//  CollectionBatch.swift//
//  Created by Vadim Pavlov on 28.07.16.

import UIKit

protocol BatchSizable {
    var batchSize: Int { get }
}

extension UITableView: BatchSizable {
    
    var batchSize: Int {
        let height = frame.height
        let rowHeight = self.batchRowHeight
        
        let visibleRows = ceil(height / rowHeight)
        
        return Int(visibleRows) * 2
    }
    
    var batchRowHeight: CGFloat {
        return estimatedRowHeight > 0 ? estimatedRowHeight : rowHeight
    }

}

extension UICollectionView: BatchSizable {
    var batchSize: Int {

        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }
        
        let height = frame.height
        let width = frame.width
        
        let itemSize = self.batchItemSize
        
        let itemsPerRow = ceil(width / (itemSize.width + flow.minimumInteritemSpacing))
        let visibleLines = ceil(height / (itemSize.height + flow.minimumLineSpacing))
        let visibleItems = visibleLines * itemsPerRow
        return Int(visibleItems) * 2
    }
    
    var batchItemSize: CGSize {
        guard let flow =  self.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSizeZero }
        let estimated = flow.estimatedItemSize
        
        if CGSizeEqualToSize(estimated, CGSizeZero) {
            return flow.itemSize
        }
        return estimated
    }
    
    func itemWidthThatFits(count: CGFloat) -> CGFloat {
        let width: CGFloat
        let inset = contentInset.left + contentInset.right
        if let flow = collectionViewLayout as? UICollectionViewFlowLayout {
            let sectionInset = flow.sectionInset.left + flow.sectionInset.right
            let spacing = flow.minimumInteritemSpacing * (count - 1)
            width = frame.width - inset - sectionInset - spacing

        } else {
            width = frame.width - inset
        }
        
        return floor(width / count)
    }
}

extension UITableViewController: BatchSizable {
    var batchSize: Int {
        return self.tableView.batchSize
    }
}

extension UICollectionViewController: BatchSizable {
    var batchSize: Int {
        return self.collectionView?.batchSize ?? 0
    }
}
