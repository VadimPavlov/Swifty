//
//  TableController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit

public class TableController<Cell: UITableViewCell, Object>: NSObject, UITableViewDataSource {

    private let config: Config<Cell, Object>
    private var dataSource: DataSource<Object>
    internal weak var tableView: UITableView?
    
    public init(tableView: UITableView, dataSource: DataSource<Object> = [], config: Config<Cell, Object>) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.config = config
        super.init()
        
        tableView.dataSource = self
        
        switch config.register {
        case .cellClass(let cls)?:
            tableView.register(cls, forCellReuseIdentifier: config.identifier)
        case .nibName(let name)?:
            let nib = UINib(nibName: name, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: config.identifier)
        default: break
        }
    }
    
    // MARK: - DataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSection()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = dataSource.numberOfObjectsInSection(section)
        return number
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: config.identifier, for: indexPath) as! Cell
        config.setup(cell, object)
        return cell
    }
    
    // MARK: - Objects
    func object(at indexPath: IndexPath) -> Object {
        return dataSource.objectAtIndexPath(indexPath)
    }
    var selectedObject: Object? {
        let indexPath = self.tableView?.indexPathForSelectedRow
        return indexPath.map { self.object(at: $0) }
    }
    
    var selectedObjects: [Object] {
        let indexPaths = self.tableView?.indexPathsForSelectedRows ?? []
        return indexPaths.map { self.object(at: $0) }
    }
    
    // MARK: - Updates
    public typealias UpdateCompletion = () -> Void

    public func update(dataSource: DataSource<Object>) {
        if self.dataSource != dataSource {
            self.dataSource = dataSource
            self.tableView?.reloadData()
        }
    }
    
    public func update(dataSource: DataSource<Object>, batch: BatchUpdate, animation: UITableViewRowAnimation = .automatic, completion: UpdateCompletion? = nil) {
        if self.dataSource != dataSource {
            self.dataSource = dataSource
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            tableView?.beginUpdates()
            self.performBatch(batch, animation: animation)
            tableView?.endUpdates()
            CATransaction.commit()
        }
    }
    
    internal func performBatch(_ batch: BatchUpdate, animation: UITableViewRowAnimation) {
        // TODO: handle known issues
        // https://techblog.badoo.com/blog/2015/10/08/batch-updates-for-uitableview-and-uicollectionview/
        
        if let sections = batch.insertSections {
            tableView?.insertSections(sections, with: animation)
        }
        if let sections = batch.reloadSections {
            tableView?.reloadSections(sections, with: animation)
        }
        if let sections = batch.deleteSections {
            tableView?.deleteSections(sections, with: animation)
        }
        if let indexes = batch.insertRows {
            tableView?.insertRows(at: indexes, with: animation)
        }
        if let indexes = batch.reloadRows {
            tableView?.reloadRows(at: indexes, with: animation)
        }
        if let indexes = batch.deleteRows {
            tableView?.deleteRows(at: indexes, with: animation)
        }
        if let move = batch.moveSection {
            tableView?.moveSection(move.at, toSection: move.to)
        }
        if let move = batch.moveRow {
            tableView?.moveRow(at: move.at, to: move.to)
        }

    }
    
}

public extension TableController {
    public convenience init(tableView: UITableView, dataSource: DataSource<Object> = [], setup: @escaping Config<Cell, Object>.Setup) {
        let config = Config(setup: setup)
        self.init(tableView: tableView, dataSource: dataSource, config: config)
    }
}
