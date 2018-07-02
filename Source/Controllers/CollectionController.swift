//
//  CollectionController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit

open class CellsCollectionController<Object>: NSObject, UICollectionViewDataSource {
    
    private var dataProvider: DataProvider<Object>
    private let cellDescriptor: (Object) -> CellDescriptor
    private var registeredCells: Set<String> = []
    private var registeredElements: Set<String> = []

    private var update: BatchUpdate?
    
    public typealias Supplementary = (IndexPath) -> SupplementaryDescriptor
    public var supplementaryDescriptor: Supplementary?
    
    public var collectionView: UICollectionView

    public init(collectionView: UICollectionView, provider: DataProvider<Object> = [], cellDescriptor: @escaping (Object) -> CellDescriptor) {
        self.collectionView = collectionView
        self.dataProvider = provider
        self.cellDescriptor = cellDescriptor
        super.init()
        collectionView.dataSource = self
    }

    // MARK: - DataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider.numberOfSection()
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfObjectsInSection(section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let object = self.object(at: indexPath)
        let descriptor = self.cellDescriptor(object)
        let identifier = descriptor.identifier
        
        self.register(cell: descriptor)

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        descriptor.configure(cell)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let descriptor = self.supplementaryDescriptor?(indexPath) else { fatalError() }
        self.register(supplementary: descriptor)
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: descriptor.kind.value, withReuseIdentifier: descriptor.identifier, for: indexPath)
        descriptor.configure(view)
        return view
    }
    
    // MARK: - Objects
    open func title(for section: Int) -> String? {
        return dataProvider.titleInSection(section)
    }

    open func object(at indexPath: IndexPath) -> Object {
        return dataProvider.objectAtIndexPath(indexPath)
    }
    
    open var selectedObject: Object? {
        let indexPath = self.collectionView.indexPathsForSelectedItems?.first
        return indexPath.map { self.object(at: $0) }
    }
    
    open var selectedObjects: [Object] {
        let indexPaths = self.collectionView.indexPathsForSelectedItems ?? []
        return indexPaths.map { self.object(at: $0) }
    }
    
    // MARK: - Updates
    public typealias UpdateCompletion = (Bool) -> Void
    public func update(provider: DataProvider<Object>, batch: BatchUpdate? = nil, completion: UpdateCompletion? = nil) {
        guard self.dataProvider !== provider else { return }
        self.dataProvider = provider
        if let batch = batch {
            self.performBatch(batch, completion: completion)
        } else {
            self.collectionView.reloadData()
        }
    }
    
    internal func performBatch(_ update: BatchUpdate, completion: UpdateCompletion? = nil) {
        
        collectionView.performBatchUpdates({
            self.collectionView.deleteSections(update.deleteSections)
            self.collectionView.insertSections(update.insertSections)
            self.collectionView.reloadSections(update.reloadSections)
            
            update.moveSections.forEach { move in
                self.collectionView.moveSection(move.at, toSection: move.to)
            }

            self.collectionView.deleteItems(at: update.deleteRows)
            self.collectionView.insertItems(at: update.insertRows)
            
            // Reloads can not be used in conjunction with other changes
            // https://techblog.badoo.com/blog/2015/10/08/batch-updates-for-uitableview-and-uicollectionview/
            update.reloadRows.forEach(self.reloadCell)
            
            update.moveRows.forEach { move in
                self.collectionView.moveItem(at: move.at, to: move.to)
            }

        }, completion: completion)
    }

    private func reloadCell(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let object = self.object(at: indexPath)
        let descriptor = self.cellDescriptor(object)
        descriptor.configure(cell)
    }

    
    private func register(cell descriptor: CellDescriptor) {
        let identifier = descriptor.identifier

        guard let register = descriptor.register,
            !registeredCells.contains(identifier) else { return }

        switch register {
        case .cls:
            let cls = descriptor.cellClass as! UICollectionViewCell.Type
            collectionView.register(cls, forCellWithReuseIdentifier: identifier)
        case .nib:
            let name = String(describing: descriptor.cellClass)
            let nib = UINib(nibName: name, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        case .nibName(let name):
            let nib = UINib(nibName: name, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        }
        registeredCells.insert(identifier)
    }

    private func register(supplementary descriptor: SupplementaryDescriptor) {
        let identifier = descriptor.identifier
        guard let register = descriptor.register,
            !registeredElements.contains(identifier) else { return }

        switch register {
        case .cls:
            let cls = descriptor.elementCls
            collectionView.register(cls, forSupplementaryViewOfKind: descriptor.kind.value, withReuseIdentifier: identifier)
        case .nib:
            let name = String(describing: descriptor.elementCls)
            let nib = UINib(nibName: name, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: descriptor.kind.value, withReuseIdentifier: identifier)
        case .nibName(let name):
            let nib = UINib(nibName: name, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: descriptor.kind.value, withReuseIdentifier: identifier)
        }
        registeredElements.insert(identifier)
    }
}


open class CollectionController<Object, Cell: UICollectionViewCell>: CellsCollectionController<Object> {
    public init(collectionView: UICollectionView, provider: DataProvider<Object> = [], identifier: String? = nil, register: CellDescriptor.Register? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(collectionView: collectionView, provider: provider) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
