//
//  TableController.swift
//  Created by Vadim Pavlov on 2/21/17.

import UIKit

open class CellsTableController<Object>: NSObject, UITableViewDataSource {

    private var dataProvider: DataProvider<Object>
    private let cellDescriptor: (Object) -> CellDescriptor

    private var registeredCells: Set<String> = []
    private var registeredViews: Set<String> = []

    public var tableView: UITableView

    public init(tableView: UITableView, provider: DataProvider<Object> = [], cellDescriptor: @escaping (Object) -> CellDescriptor) {
        self.tableView = tableView
        self.dataProvider = provider
        self.cellDescriptor = cellDescriptor
        super.init()
        tableView.dataSource = self
    }

    // MARK: - DataProvider
    open func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.numberOfSection()
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfObjectsInSection(section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.object(at: indexPath)
        let descriptor = self.cellDescriptor(object)
        let identifier = descriptor.identifier
        
        self.register(cell: descriptor)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        descriptor.configure(cell, indexPath)
        return cell
    }
    
    // MARK: - Objects
    open func title(for section: Int) -> String? {
        return dataProvider.titleInSection(section)
    }    
    open func object(at indexPath: IndexPath) -> Object {
        return dataProvider.objectAtIndexPath(indexPath)
    }
    open var selectedObject: Object? {
        let indexPath = self.tableView.indexPathForSelectedRow
        return indexPath.map { self.object(at: $0) }
    }
    
    open var selectedObjects: [Object] {
        let indexPaths = self.tableView.indexPathsForSelectedRows ?? []
        return indexPaths.map { self.object(at: $0) }
    }
    
    // MARK: - Updates
    public typealias UpdateCompletion = () -> Void

    public func update(provider: DataProvider<Object>, batch: BatchUpdate? = nil, completion: UpdateCompletion? = nil) {
        guard self.dataProvider !== provider else { return }

        self.dataProvider = provider
        if let batch = batch {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            tableView.beginUpdates()
            self.performBatch(batch)
            tableView.endUpdates()
            CATransaction.commit()
        } else {
            tableView.reloadData()
        }
    }
    
    internal func performBatch(_ update: BatchUpdate) {
        let animation = update.animation
        // https://techblog.badoo.com/blog/2015/10/08/batch-updates-for-uitableview-and-uicollectionview/

        // Simultaneous updates of sections and items lead to the mentioned exceptions and incorrect internal states of views
        tableView.deleteSections(update.deleteSections, with: animation)
        tableView.insertSections(update.insertSections, with: animation)
        tableView.reloadSections(update.reloadSections, with: animation)
        update.moveSections.forEach { move in
            tableView.moveSection(move.at, toSection: move.to)
        }
        
        tableView.deleteRows(at: update.deleteRows, with: animation)
        tableView.insertRows(at: update.insertRows, with: animation)
        
        // Reloads can not be used in conjunction with other changes
        update.reloadRows.forEach(self.reloadCell)
        
        update.moveRows.forEach { move in
            tableView.moveRow(at: move.at, to: move.to)
        }
    }

    private func reloadCell(at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let object = self.object(at: indexPath)
        let descriptor = self.cellDescriptor(object)
        descriptor.configure(cell, indexPath)
    }

    private func register(cell descriptor: CellDescriptor) {
        let identifier = descriptor.identifier
        guard let register = descriptor.register else { return }
        guard !registeredCells.contains(identifier) else { return }

        switch register {
        case .cls:
            let cls = descriptor.cellClass as! UITableViewCell.Type
            tableView.register(cls, forCellReuseIdentifier: identifier)
        case .nib:
            let name = String(describing: descriptor.cellClass)
            let nib = UINib(nibName: name, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: identifier)
        case .nibName(let name):
            let nib = UINib(nibName: name, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: identifier)
        }
        registeredCells.insert(identifier)
    }

    /* ### Call for header-footer view is happens in delegate ###
    public func register<View: UITableViewHeaderFooterView>(view descriptor: HeaderFooterDescriptor<View>) {
        let identifier = descriptor.identifier
        guard let register = descriptor.register else { return }
        guard !registeredViews.contains(identifier) else { return }

        switch register {
        case .cls:
            tableView.register(View.self, forHeaderFooterViewReuseIdentifier: identifier)
        case .nib:
            let name = String(describing: View.self)
            let nib = UINib(nibName: name, bundle: nil)
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        case .nibName(let name):
            let nib = UINib(nibName: name, bundle: nil)
            tableView.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        }
        registeredViews.insert(identifier)
    }
    */
}

open class TableController <Object, Cell: UITableViewCell>: CellsTableController<Object> {
    
    public init(tableView: UITableView, provider: DataProvider<Object> = [], identifier: String? = nil, register: Register? = nil, configure: @escaping (Cell, Object, IndexPath) -> Void) {
        super.init(tableView: tableView, provider: provider) { object in
            let descriptor = CellDescriptor(identifier: identifier, register: register, configure: { cell, indexPath  in
                configure(cell, object, indexPath)
            })
            return descriptor
        }
    }
}
