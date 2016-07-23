//
//  ArrayDataSource.swift
//  Created by Vadim Pavlov on 3/30/16.

import UIKit

public class ArrayDataSource<Cell, Object>: NSObject {
    let array: Array<Object>
    let identifier: String
    let configuration: Configuration
    typealias Configuration = (cell: Cell, object: Object) -> Void
    
    init(array: Array<Object>, identifier: String = String(Cell), configuration: Configuration) {
        self.array = array
        self.identifier = identifier
        self.configuration = configuration
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        return self.array[indexPath.row]
    }
}

public class CollectionArrayDataSource <Cell: UICollectionViewCell, Object>: ArrayDataSource<Cell, Object>, UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.array.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.identifier, forIndexPath: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        let object = self.objectAtIndexPath(indexPath)
        self.configuration(cell: cell, object: object)
        return cell
    }
}

public class TableArrayDataSource <Cell: UITableViewCell, Object>: ArrayDataSource<Cell, Object>, UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(self.identifier, forIndexPath: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        let object = self.objectAtIndexPath(indexPath)
        self.configuration(cell: cell, object: object)
        return cell
    }
}