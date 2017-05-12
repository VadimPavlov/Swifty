//
//  CollectionController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit

public class CollectionController<Cell: UICollectionViewCell, Object>: NSObject, UICollectionViewDataSource {
    
    private var dataSource: DataSource<Object>
    private let config: Config<Cell, Object>
    weak var collectionView: UICollectionView? {
        didSet { self.adapt(collectionView)}
    }
    
    public init(collectionView: UICollectionView? = nil, dataSource: DataSource<Object> = [], config: Config<Cell, Object>) {
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.config = config
        super.init()
        self.adapt(collectionView)
    }
    
    private func adapt(_ collectionView: UICollectionView?) {
        guard let collectionView = collectionView else { return }
        collectionView.dataSource = self
        
        switch config.register {
        case .cellClass(let cls)?:
            collectionView.register(cls, forCellWithReuseIdentifier: config.identifier)
        case .nibName(let name)?:
            let nib = UINib(nibName: name, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: config.identifier)
        default: break
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: config.identifier, for: indexPath) as! Cell
        config.setup(cell, object)
        return cell
    }
    
    // MARK: - Objects
    func object(at indexPath: IndexPath) -> Object {
        return dataSource.objectAtIndexPath(indexPath)
    }
    var selectedObject: Object? {
        let indexPath = self.collectionView?.indexPathsForSelectedItems?.first
        return indexPath.map { self.object(at: $0) }
    }
    
    var selectedObjects: [Object] {
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

public extension CollectionController {
    public convenience init(collectionView: UICollectionView, dataSource: DataSource<Object> = [], setup: @escaping Config<Cell, Object>.Setup) {
        let config = Config(setup: setup)
        self.init(collectionView: collectionView, dataSource: dataSource, config: config)
    }
}
