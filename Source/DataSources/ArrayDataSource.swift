//
//  ArrayDataSource.swift
//  Created by Vadim Pavlov on 3/30/16.

import UIKit

public class ArrayDataSource<Cell, Object>: NSObject {
	public var array: [Object] = []
    public let identifier: String
    public let configuration: Configuration
    public typealias Configuration = (cell: Cell, object: Object) -> Void
    
    init(identifier: String = String(Cell), configuration: Configuration) {
        self.identifier = identifier
        self.configuration = configuration
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        return self.array[indexPath.row]
    }
	
	public func clear() {
		array.removeAll()
	}
}

public class TableArrayDataSource <Cell: UITableViewCell, Object>: ArrayDataSource<Cell, Object>, UITableViewDataSource, UITableViewDelegate {
	
	unowned var tableView: UITableView
    var delegate: UITableViewDelegate?
    
	public init(_ tableView: UITableView, identifier: String = String(Cell), registerNib: Bool = false, configuration: Configuration) {
		self.tableView = tableView
		super.init(identifier: identifier, configuration: configuration)
		tableView.dataSource = self
        
	}
    
	override public var array: [Object] {
		didSet { tableView.reloadData() }
	}
	
//	public override func clear() {
//		super.clear()
//		tableView.reloadData()
//	}
	
    // MARK: - UITableViewDataSource

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
    
    // MARK: - UITableViewDelegate
    public typealias SelectedObject = (Object, NSIndexPath)
    public var didSelectObject: (SelectedObject -> Void)? {
        didSet {
            delegate = tableView.delegate
            tableView.delegate = self
        }
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.tableView?(tableView, didSelectRowAtIndexPath: indexPath)
        let object = objectAtIndexPath(indexPath)
        didSelectObject?(object, indexPath)
    }
}

public class CollectionArrayDataSource <Cell: UICollectionViewCell, Object>: ArrayDataSource<Cell, Object>, UICollectionViewDataSource, UICollectionViewDelegate {
	
	unowned var collectionView: UICollectionView
    weak var delegate: UICollectionViewDelegate?
    
	public init(_ collectionView: UICollectionView, identifier: String = String(Cell), registerNib: Bool = false, configuration: Configuration) {
		self.collectionView = collectionView
		super.init(identifier: identifier, configuration: configuration)
		collectionView.dataSource = self
        
        if registerNib {
            let nib = UINib(nibName: identifier, bundle: nil)
            collectionView.registerNib(nib, forCellWithReuseIdentifier: identifier)
        }

	}
	
    override public var array: [Object] {
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
    
    // MARK: - UICollectionViewDelegate
    public typealias SelectedObject = (Object, NSIndexPath)
    public var didSelectObject: (SelectedObject -> Void)? {
        didSet {
            delegate = collectionView.delegate
            collectionView.delegate = self
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.collectionView?(collectionView, didSelectItemAtIndexPath: indexPath)
        
        let object = objectAtIndexPath(indexPath)
        didSelectObject?(object, indexPath)
        
    }
}