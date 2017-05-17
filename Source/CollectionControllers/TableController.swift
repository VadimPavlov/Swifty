//
//  TableController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit

public class TableController<Object>: NSObject, UITableViewDataSource {

    private var dataSource: DataSource<Object>
    private let cellDescriptor: (Object) -> CellDescriptor
    private var registeredIdentifiers: Set<String> = []
    
    internal weak var tableView: UITableView? {
        didSet { self.adapt(tableView: tableView) }
    }

    public init(tableView: UITableView, dataSource: DataSource<Object> = [], cellDescriptor: @escaping (Object) -> CellDescriptor) {
        self.tableView = tableView
        self.dataSource = dataSource
        self.cellDescriptor = cellDescriptor
        super.init()
        self.adapt(tableView: tableView)
    }
    
    private func adapt(tableView: UITableView?) {
        tableView?.dataSource = self
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
        let descriptor = self.cellDescriptor(object)
        let identifier = descriptor.identifier
        
        if let register = descriptor.register, !registeredIdentifiers.contains(identifier) {
            switch register {
            case .cellClass:
                let cls = descriptor.cellClass as! UITableViewCell.Type
                tableView.register(cls, forCellReuseIdentifier: identifier)
            case .nibName(let name):
                let nibName = name ?? String(describing: descriptor.cellClass)
                let nib = UINib(nibName: nibName, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: identifier)
            }
            registeredIdentifiers.insert(identifier)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        descriptor.configure(cell)
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

public class SimpleTableController <Object, Cell: UITableViewCell>: TableController<Object> {
    
    public init(tableView: UITableView, dataSource: DataSource<Object> = [], identifier: String? = nil, register: CellDescriptor.Register? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(tableView: tableView, dataSource: dataSource) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
