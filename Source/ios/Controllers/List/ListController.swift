//
//  ListController.swift
//  Created by Vadim Pavlov on 3/7/17.

import Foundation

public protocol ListControllerDataSource: class {
    func loadPage(_ page: ListPage) -> Future<[ListObject]>
    func canLoadMore(after page: ListPage, loaded objects: [ListObject]) -> Bool
}

public extension ListControllerDataSource {
    func canLoadMore(after page: ListPage, loaded objects: [ListObject]) -> Bool {
        return objects.count == page.size
    }
}

open class ListController: StateController<ListViewState> {
    
    public let pageSize: Int
    public let firstPage: Int
    public var currentPage: Int
    public var lastID: String?
    public var section: Int = 0

    public let objects = Atomic<[ListObject]>([])
    public weak var dataSource: ListControllerDataSource?
    
    private typealias ListUpdateAction = (BatchUpdate?) -> Void
    private var listUpdate: ListUpdateAction?
    
    open override func setView<View : ListViewType>(_ view: View) where View.State == ListViewState {
        super.setView(view)
        self.listUpdate = { [weak view, weak self] update in
            assert(Thread.isMainThread)
            let list = self?.objects.value as? [View.ListViewObject] ?? []

            if self?.state.isEmpty != list.isEmpty {
                self?.state.isEmpty = list.isEmpty
            }

            if view?.isViewLoaded == true {
                view?.update(list: list, batch: update)
            }
        }
    }

    public init(pageSize: Int, firstPage: Int, currentPage: Int? = nil, objects: [ListObject] = []) {
        self.pageSize = pageSize
        self.firstPage = firstPage
        self.currentPage = currentPage ?? firstPage
        self.objects.value = objects

        let state = ListViewState()
        super.init(state: state)

    }

    // MARK: - Loading
    public func clear() {
        self.lastID = nil
        self.state.canLoadMore = true
        self.currentPage = firstPage
        self.update(objects: [])
    }
    
    public func loadFirstPage() {
        self.clear()

        let page = ListPage(size: pageSize, number: firstPage,  lastID: nil)
        self.loadPage(page) { [weak self] objects in
            self?.appendNewPage(page, with: objects)
        }
    }
    
    public func loadNextPage() {
        guard state.canLoadMore else { return }
        let nextPage = ListPage(size: pageSize, number: currentPage + 1,  lastID: self.lastID)
        self.loadPage(nextPage) { [weak self] objects in
            self?.appendNewPage(nextPage, with: objects)
        }
    }
    
    // MARK: - Refreshing
    public enum RefreshGapStrategy {
        case dropLoaded
        case keepLoading
    }
    
    public func refresh(onGap: RefreshGapStrategy) {
        let page = ListPage(size: pageSize, number: firstPage,  lastID: nil)
        if let firstID = self.objects.value.first?.listID {
            self.refreshPage(page, firstID: firstID, onGap: onGap)
        } else {
            self.loadFirstPage()
        }
    }
    
    private func loadPage(_ page: ListPage, completion: @escaping ([ListObject]) -> Void) {
        
        guard !state.isLoading else { return }
        self.state.isLoading = true
        
        self.dataSource?.loadPage(page).start { [weak self] result in
            self?.state.isLoading = false
            switch result {
            case .success(let objects):
                completion(objects)
            case .error(let error):
                self?.showError(error)
            }
        }
    }
    
    private func refreshPage(_ page: ListPage, firstID: String, onGap: RefreshGapStrategy) {
        self.loadPage(page) { [weak self] objects in
            
            let newObjects = objects.prefix { object in
                object.listID != firstID
            }
            
            guard !newObjects.isEmpty else { return }
            
            if newObjects.count == page.size {
                // potential gap between new & loaded objects
                switch onGap {
                case .dropLoaded:
                    self?.clear()
                    self?.appendNewPage(page, with: Array(newObjects))
                case .keepLoading:
                    let nextPage = ListPage(size: page.size, number: page.number + 1,  lastID: nil)
                    self?.refreshPage(nextPage, firstID: firstID, onGap: onGap)
                }
            } else {
                self?.insertObjects(Array(newObjects))
            }
        }
    }
    
    open func appendNewPage(_ page: ListPage, with objects: [ListObject]) {
        self.currentPage = page.number
        self.lastID = objects.last?.listID

        // ask data source first
        if let canLoadMore = self.dataSource?.canLoadMore(after: page, loaded: objects) {
            if self.state.canLoadMore != canLoadMore {
                self.state.canLoadMore = canLoadMore
            }
        } else if objects.count < page.size {
            self.state.canLoadMore = false
        }

        self.appendObjects(objects)
    }
    
}

// MARK: - Updating
public extension ListController {
    func updateList() {
        self.listUpdate?(nil)
    }

    func update(objects: [ListObject]) {
        self.objects.value = objects
        updateList()
    }
    
    func updateObject(_ object: ListObject) -> Int? {
        let index = self.objects.value.index { $0.listID == object.listID }
        if let item = index {
            
            let ip = IndexPath(item: item, section: section)
            let update = BatchUpdate(reloadRows: [ip])
            
            self.objects.value[item] = object
            self.listUpdate?(update)
        }

        return index
    }

    // MARK: Insert
    func appendObjects(_ newObjects: [ListObject]) {

        let lower = self.objects.value.count
        let upper = lower + newObjects.count
        let range = lower..<upper
        
        let inserted = range.map { IndexPath(row: $0, section: section) }
        let update = BatchUpdate(insertRows: inserted)

        self.objects.mutate { objects in
            objects.append(contentsOf: newObjects)
        }
        self.listUpdate?(update)
    }
    
    func insertObject(_ object: ListObject, at index: Int = 0) {
        let indexPath = IndexPath(row: index, section: section)
        let update = BatchUpdate(insertRows: [indexPath])

        self.objects.mutate { objects in
            objects.insert(object, at: index)
        }
        self.listUpdate?(update)
    }
    
    func insertObjects(_ newObjects: [ListObject], at index: Int = 0) {
        guard !newObjects.isEmpty else { return }

        self.objects.mutate { objects in
            objects.insert(contentsOf: newObjects, at: index)
        }

        let lower = index
        let upper = lower + newObjects.count
        let range = lower..<upper
        
        let inserted = range.map { IndexPath(row: $0, section: section) }
        let update = BatchUpdate(insertRows: inserted)

        self.listUpdate?(update)
    }

    // MARK: Remove
    func removeObject(at index: Int) {
        let indexPath = IndexPath(row: index, section: section)
        let update = BatchUpdate(deleteRows: [indexPath])
        self.objects.mutate { objects in
            objects.remove(at: index)
        }
        self.listUpdate?(update)
    }
    
    func removeObject(_ object: ListObject) -> Int? {
        let index = self.objects.value.index { $0.listID == object.listID }
        if let index = index {
            self.removeObject(at: index)
        }
        return index
    }
    
    func removeObjects(_ objects: [ListObject]) {
        guard !objects.isEmpty else { return }

        var indexPaths: [IndexPath] = []
        
        // reverse arrays, so we can remove current idx in loop
        let reversedObjects = objects.reversed()
        self.objects.mutate { objects in
            objects.enumerated().reversed().forEach { index, object in
                let contains = reversedObjects.contains { $0.listID == object.listID }
                if contains {
                    objects.remove(at: index)
                    let ip = IndexPath(row: index, section: self.section)
                    indexPaths.insert(ip, at: 0)
                }
            }
        }
        
        let update = BatchUpdate(deleteRows: indexPaths)
        self.listUpdate?(update)
    }

    // MARK: Move
    func moveObject(_ object: ListObject, to index: Int) {
        guard let row = objects.value.index(where: { $0.listID == object.listID }) else { return }
        move(from: row, to: index)
    }

    func move(from: Int, to index: Int) {
        guard from != index else { return }

        let at = IndexPath(row: from, section: section)
        let to = IndexPath(row: index, section: section)

        let move = Move<IndexPath>(at: at, to: to)
        let update = BatchUpdate(moveRows: [move])

        self.objects.mutate { objects in
            let object = objects.remove(at: from)
            objects.insert(object, at: index)
        }
        self.listUpdate?(update)
    }
}
