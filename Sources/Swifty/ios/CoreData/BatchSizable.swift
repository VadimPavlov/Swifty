//  BatchSizable.swift
//  Created by Vadim Pavlov on 28.07.16.

import UIKit

let BatchVisibleMultiplier = 2
public protocol BatchSizable {
    var batchSize: Int { get }
}

extension UITableView: BatchSizable {
    
    public var batchSize: Int {
        let height = frame.height
        let rowHeight = self.batchRowHeight
        
        let visibleRows = ceil(height / rowHeight)
        
        return Int(visibleRows) * BatchVisibleMultiplier
    }
    
    private var batchRowHeight: CGFloat {
        return estimatedRowHeight > 0 ? estimatedRowHeight : rowHeight
    }

}

extension UICollectionView: BatchSizable {

    public var batchSize: Int {

        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }
        
        let height = frame.height
        let width = frame.width
        
        let itemSize = self.batchItemSize
        
        let itemsPerRow = ceil(width / (itemSize.width + flow.minimumInteritemSpacing))
        let visibleLines = ceil(height / (itemSize.height + flow.minimumLineSpacing))
        let visibleItems = visibleLines * itemsPerRow
        return Int(visibleItems) * BatchVisibleMultiplier
    }
    
    private var batchItemSize: CGSize {
        guard let flow =  self.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let estimated = flow.estimatedItemSize
        
        if estimated.equalTo(.zero) {
            return flow.itemSize
        }
        return estimated
    }
}

extension UITableViewController: BatchSizable {
    public var batchSize: Int {
        return self.tableView.batchSize
    }
}

extension UICollectionViewController: BatchSizable {
    public var batchSize: Int {
        return self.collectionView?.batchSize ?? 0
    }
}
