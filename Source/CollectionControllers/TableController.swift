//
//  TableController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit

open class CellsTableController<Object>: NSObject, UITableViewDataSource {

    private var dataSource: DataSource<Object>
    private let cellDescriptor: (Object) -> CellDescriptor
    private var registeredCells: Set<String> = []
    
    public weak var tableView: UITableView? {
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
    open func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSection()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfObjectsInSection(section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.object(at: indexPath)
        let descriptor = self.cellDescriptor(object)
        let identifier = descriptor.identifier
        
        self.register(cell: descriptor)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        descriptor.configure(cell)
        return cell
    }
    
    // MARK: - Objects
    open func title(for section: Int) -> String? {
        return dataSource.titleInSection(section)
    }    
    open func object(at indexPath: IndexPath) -> Object {
        return dataSource.objectAtIndexPath(indexPath)
    }
    open var selectedObject: Object? {
        let indexPath = self.tableView?.indexPathForSelectedRow
        return indexPath.map { self.object(at: $0) }
    }
    
    open var selectedObjects: [Object] {
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
    
    internal func performBatch(_ update: BatchUpdate, animation: UITableViewRowAnimation) {
        
        // https://techblog.badoo.com/blog/2015/10/08/batch-updates-for-uitableview-and-uicollectionview/

        // Simultaneous updates of sections and items lead to the mentioned exceptions and incorrect internal states of views
        tableView?.deleteSections(update.deleteSections, with: animation)
        tableView?.insertSections(update.insertSections, with: animation)
        tableView?.reloadSections(update.reloadSections, with: animation)
        update.moveSections.forEach { move in
            tableView?.moveSection(move.at, toSection: move.to)
        }
        
        tableView?.deleteRows(at: update.deleteRows, with: animation)
        tableView?.insertRows(at: update.insertRows, with: animation)
        
        // Reloads can not be used in conjunction with other changes
        update.reloadRows.forEach(self.reloadCell)
        
        update.moveRows.forEach { move in
            tableView?.moveRow(at: move.at, to: move.to)
        }
    
    }
    private func reloadCell(at indexPath: IndexPath) {
        guard let cell = tableView?.cellForRow(at: indexPath) else { return }
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
            let cls = descriptor.cellClass as! UITableViewCell.Type
            tableView?.register(cls, forCellReuseIdentifier: identifier)
        case .nib:
            let nibName = String(describing: descriptor.cellClass)
            let nib = UINib(nibName: nibName, bundle: nil)
            tableView?.register(nib, forCellReuseIdentifier: identifier)
        case .nibName(let name):
            let nib = UINib(nibName: name, bundle: nil)
            tableView?.register(nib, forCellReuseIdentifier: identifier)
        }
        registeredCells.insert(identifier)
    }
}

open class TableController <Object, Cell: UITableViewCell>: CellsTableController<Object> {
    
    public init(tableView: UITableView, dataSource: DataSource<Object> = [], identifier: String? = nil, register: CollectionItemRegistration? = nil, configure: @escaping (Cell, Object) -> Void) {
        super.init(tableView: tableView, dataSource: dataSource) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell in
                configure(cell, object)
            })
            return descriptor
        }
    }
}
