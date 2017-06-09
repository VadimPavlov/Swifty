//
//  ListController.swift
//  Created by Vadim Pavlov on 3/7/17.

import Foundation

public typealias ListPageLoadingCompletion = (Result<[ListObject]>) -> Void

public protocol ListControllerDataSource: class {
    func loadPage(_ page: ListPage, completion: @escaping ListPageLoadingCompletion)
}

public class ListController: StateController<ListState> {
    
    private let pageSize: Int
    private var lastID: String?
    private let appendAnimated: Bool
    
    public private(set) var objects: [ListObject]
    public weak var dataSource: ListControllerDataSource?
    
    private typealias ListUpdateAction = (BatchUpdate?, Bool) -> Void
    private var listUpdate: ListUpdateAction?
    
    public override func setView<View : ListViewType>(_ view: View) where View.State == ListState {
        super.setView(view)
        self.listUpdate = { [weak view, weak self] update, animated in
            let objects = self?.objects ?? []
            assert(Thread.isMainThread)
            view?.update(list: objects, batch: update, animated: animated)
        }
    }
    
    init(pageSize: Int, objects: [ListObject] = [], appendAnimated: Bool = true) {
        self.pageSize = pageSize
        self.objects = objects
        self.appendAnimated = appendAnimated
                
        let state = ListState()
        super.init(state: state)
    }

    // MARK: - Loading

    func loadFirstPage() {
        self.lastID = nil
        
        let page = ListPage(size: pageSize, lastID: nil)
        self.loadPage(page)
    }
    
    func loadNextPage() {
        let nextPage = ListPage(size: pageSize, lastID: self.lastID)
        self.loadPage(nextPage)
    }
    
    private func loadPage(_ page: ListPage) {
        
        guard state.isLoading == false, state.canLoadMore else { return }
        
        self.state.isLoading = true
        
        self.dataSource?.loadPage(page) { [weak self] result in
            self?.state.isLoading = false
            switch result {
            case .success(let objects):
                self?.appendNewPage(with: objects)
                
                if objects.count > 0 && self?.state.isEmpty == true {
                    self?.state.isEmpty = false
                }
                
                if objects.count < page.size {
                    self?.state.canLoadMore = false
                }
                
            case .error(let error):
                self?.showError(error)
                self?.state.canLoadMore = false // ? depends from error?
            }
        }
    }
    
    func appendNewPage(with objects: [ListObject]) {
        self.lastID = objects.last?.id
        self.appendObjects(objects, animated: self.appendAnimated)
    }
    
    // MARK: - Updating
    func update(objects: [ListObject]) {
        self.objects = objects
        self.listUpdate?(nil, false)
    }
    
    func updateObject(_ object: ListObject, animated: Bool) {
        let index = self.objects.index { $0.id == object.id }
        if let item = index {
            
            let ip = IndexPath(item: item, section: 0)
            let update = BatchUpdate(reloadRows: [ip])
            
            self.objects[item] = object
            self.listUpdate?(update, animated)
        }
    }
    
    func appendObjects(_ newObjects: [ListObject], animated: Bool) {
        
        let lower = self.objects.count
        let upper = lower + newObjects.count
        let range = lower..<upper
        
        let inserted = range.map { IndexPath(row: $0, section: 0) }
        let update = BatchUpdate(insertRows: inserted)
        
        self.objects.append(contentsOf: newObjects)
        self.listUpdate?(update, animated)
    }
    
    func insertObject(_ object: ListObject, at index: Int = 0, animated: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        let update = BatchUpdate(insertRows: [indexPath])

        self.objects.insert(object, at: index)
        self.listUpdate?(update, animated)
    }
    
    func insertObjects(_ newObjects: [ListObject], at index: Int = 0, animated: Bool) {
        self.objects.insert(contentsOf: newObjects, at: index)
        
        let lower = index
        let upper = lower + newObjects.count
        let range = lower..<upper
        
        let inserted = range.map { IndexPath(row: $0, section: 0) }
        let update = BatchUpdate(insertRows: inserted)

        self.listUpdate?(update, animated)
    }
    
    func removeObject(at index: Int, animated: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        let update = BatchUpdate(deleteRows: [indexPath])
        self.objects.remove(at: index)
        self.listUpdate?(update, animated)
    }
    
    func removeObject(_ object: ListObject, animated: Bool) {
        let index = self.objects.index { $0.id == object.id }
        if let index = index {
            self.removeObject(at: index, animated: animated)
        }
    }
    
    func removeObjects(_ objects: [ListObject], animated: Bool) {
        var indexPaths: [IndexPath] = []
        
        // reverse arrays, so we can remove current idx in loop
        let reversedObjects = objects.reversed()
        for (idx, object) in self.objects.enumerated().reversed() {
            let contains = reversedObjects.contains { $0.id == object.id }
            if contains {
                self.objects.remove(at: idx)
                let ip = IndexPath(row: idx, section: 0)
                indexPaths.insert(ip, at: 0)
            }
        }
        
        let update = BatchUpdate(deleteRows: indexPaths)
        self.listUpdate?(update, animated)
    }
    
}