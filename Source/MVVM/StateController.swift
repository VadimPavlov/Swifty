//
//  StateController.swift
//  Created by Vadim Pavlov on 2/21/17.

import Foundation

open class StateController<State> {
    
    private typealias UpdateAction = (State, State?) -> Void
    private typealias ShowErrorAction = (Error) -> Void
    
    private var update: UpdateAction?
    private var showError: ShowErrorAction?
    
    open var state: State {
        didSet {
            self.update?(state, oldValue)
        }
    }
    
    open func setView<View:ViewType>(_ view: View) where View.State == State {
        
        self.update = { [weak view] newState, oldState in
            assert(Thread.isMainThread)
            if view?.isViewLoaded == true {
                view?.update(state: newState, oldState: oldState)
            }
        }
        
        self.showError = { [weak view] error in
            assert(Thread.isMainThread)
            view?.showError(error)
        }
    }
    
    public init(state: State) {
        self.state = state
    }
    
    public func updateState() {
        update?(self.state, nil)
    }
    
    public func showError(_ error: Error) {
        showError?(error)
    }
}
