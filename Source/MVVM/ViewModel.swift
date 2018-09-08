//
//  ViewModel.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

open class ViewModel<View: ViewType> {
    
    public typealias State = View.State

    public weak var view: View?
    open var state: State {
        didSet {
            self.update(state: state, oldState: oldValue)
        }
    }
    
    public init(state: State) {
        self.state = state
    }
    
    public func updateState() {
        self.update(state: state, oldState: nil)
    }
    
    public func showError(_ error: Error) {
        assert(Thread.isMainThread)
        view?.showError(error)
    }
    
    private func update(state: State, oldState: State?) {
        assert(Thread.isMainThread)
        if view?.isViewLoaded == true {
            view?.update(state: state, oldState: oldState)
        }
    }
}
