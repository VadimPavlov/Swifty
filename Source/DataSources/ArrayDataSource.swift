//
//  ArrayDataSource.swift
//  Created by Vadim Pavlov on 3/30/16.

import UIKit

open class ArrayDataSource<Cell, Object>: NSObject {
	open var array: [Object] = []
    open let identifier: String
    open let configuration: Configuration
    public typealias Configuration = (_ cell: Cell, _ object: Object) -> Void
    
    init(identifier: String = String(describing: Cell.self), configuration: @escaping Configuration) {
        self.identifier = identifier
        self.configuration = configuration
    }
    
    open func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        return self.array[(indexPath as NSIndexPath).row]
    }
	
	open func clear() {
		array.removeAll()
	}
}

open class TableArrayDataSource <Cell: UITableViewCell, Object>: ArrayDataSource<Cell, Object>, UITableViewDataSource, UITableViewDelegate {
	
	unowned var tableView: UITableView
    var delegate: UITableViewDelegate?
    
	public init(_ tableView: UITableView, identifier: String = String(describing: Cell.self), registerNib: Bool = false, configuration: @escaping Configuration) {
		self.tableView = tableView
		super.init(identifier: identifier, configuration: configuration)
		tableView.dataSource = self
        
	}
    
	override open var array: [Object] {
		didSet { tableView.reloadData() }
	}
	
//	public override func clear() {
//		super.clear()
//		tableView.reloadData()
//	}
	
    // MARK: - UITableViewDataSource

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
        let object = self.objectAtIndexPath(indexPath)
        self.configuration(cell, object)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    open var didSelectObject: ((Object, IndexPath) -> Void)? {
        didSet {
            delegate = tableView.delegate
            tableView.delegate = self
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        let object = objectAtIndexPath(indexPath)
        didSelectObject?(object, indexPath)
    }
}

open class CollectionArrayDataSource <Cell: UICollectionViewCell, Object>: ArrayDataSource<Cell, Object>, UICollectionViewDataSource, UICollectionViewDelegate {
	
	unowned var collectionView: UICollectionView
    weak var delegate: UICollectionViewDelegate?
    
	public init(_ collectionView: UICollectionView, identifier: String = String(describing: Cell.self), registerNib: Bool = false, configuration: @escaping Configuration) {
		self.collectionView = collectionView
		super.init(identifier: identifier, configuration: configuration)
		collectionView.dataSource = self
        
        if registerNib {
            let nib = UINib(nibName: identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        }

	}
	
    override open var array: [Object] {
        didSet { collectionView.reloadData() }
    }

//    public func setArray(reload: Bool = true) {
//        self.array = array
//        if reload {
//            collectionView.reloadData()
//        }
//    }
    
//	public override func clear() {
//		super.clear()
//		collectionView.reloadData()
//	}

    // MARK: - UICollectionViewDataSource
	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.array.count
	}
	
	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? Cell else { fatalError("Incorrect cell at \(indexPath)") }
		let object = self.objectAtIndexPath(indexPath)
		self.configuration(cell, object)
		return cell
	}
    
    // MARK: - UICollectionViewDelegate
    open var didSelectObject: ((Object, IndexPath) -> Void)? {
        didSet {
            delegate = collectionView.delegate
            collectionView.delegate = self
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        
        let object = objectAtIndexPath(indexPath)
        didSelectObject?(object, indexPath)
        
    }
}
