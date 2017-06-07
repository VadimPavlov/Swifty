//
//  CollectionController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit

public class CollectionController<Object>: NSObject, UICollectionViewDataSource {
    
    private var dataSource: DataSource<Object>
    private let cellDescriptor: (Object) -> CellDescriptor
    
    internal weak var collectionView: UICollectionView? {
        didSet { self.adapt(collectionView)}
    }

    public init(collectionView: UICollectionView? = nil, dataSource: DataSource<Object> = [], cellDescriptor: @escaping (Object) -> CellDescriptor) {
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.cellDescriptor = cellDescriptor
        super.init()
        self.adapt(collectionView)
    }
    
    private func adapt(_ collectionView: UICollectionView?) {
        collectionView?.dataSource = self
    }
    
    // MARK: - DataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.numberOfSection()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfObjectsInSection(section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let object = self.object(at: indexPath)
        let descriptor = self.cellDescriptor(object)
        let identifier = descriptor.identifier
        
        switch descriptor.register {
        case .cellClass?:
            let cls = descriptor.cellClass as! UICollectionViewCell.Type
            collectionView.register(cls, forCellWithReuseIdentifier: identifier)
        case .nibName(let name)?:
            let nibName = name ?? String(describing: descriptor.cellClass)
            let nib = UINib(nibName: nibName, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        default: break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        descriptor.configure(cell)
        return cell
    }
    
    // MARK: - Objects
    public func object(at indexPath: IndexPath) -> Object {
        return dataSource.objectAtIndexPath(indexPath)
    }
    public var selectedObject: Object? {
        let indexPath = self.collectionView?.indexPathsForSelectedItems?.first
        return indexPath.map { self.object(at: $0) }
    }
    
    public var selectedObjects: [Object] {
        let indexPaths = self.collectionView?.indexPathsForSelectedItems ?? []
        return indexPaths.map { self.object(at: $0) }
    }
    
    // MARK: - Updates
    public typealias UpdateCompletion = (Bool) -> Void
    
    public func update(dataSource: DataSource<Object>) {
        if self.dataSource != dataSource {
            self.dataSource = dataSource
            self.collectionView?.reloadData()
        }
    }
    
    public func update(dataSource: DataSource<Object>, batch: BatchUpdate, completion: UpdateCompletion? = nil) {
        if self.dataSource != dataSource {
            self.dataSource = dataSource
            self.performBatch(batch, completion: completion)
        }
    }
    
    internal func performBatch(_ batch: BatchUpdate, completion: UpdateCompletion? = nil) {
        // TODO: handle known issues
        // https://techblog.badoo.com/blog/2015/10/08/batch-updates-for-uitableview-and-uicollectionview/
        
        collectionView?.performBatchUpdates({
            if let sections = batch.insertSections {
                self.collectionView?.insertSections(sections)
            }
            if let sections = batch.reloadSections {
                self.collectionView?.reloadSections(sections)
            }
            if let sections = batch.deleteSections {
                self.collectionView?.deleteSections(sections)
            }
            if let indexes = batch.insertRows {
                self.collectionView?.insertItems(at: indexes)
            }
            if let indexes = batch.reloadRows {
                self.collectionView?.reloadItems(at: indexes)
            }
            if let indexes = batch.deleteRows {
                self.collectionView?.deleteItems(at: indexes)
            }
            if let move = batch.moveSection {
                self.collectionView?.moveSection(move.at, toSection: move.to)
            }
            
            if let move = batch.moveRow {
                self.collectionView?.moveItem(at: move.at, to: move.to)
            }
            
        }, completion: completion)
    }
}

public class SimpleCollectionController<Object, Cell: UICollectionViewCell>: CollectionController<Object> {
    public init(collectionView: UICollectionView, dataSource: DataSource<Object> = [], identifier: String? = nil, register: CellDescriptor.Register? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(collectionView: collectionView, dataSource: dataSource) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
