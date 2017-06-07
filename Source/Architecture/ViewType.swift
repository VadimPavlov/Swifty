//
//  ViewType.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public protocol ViewType: class {
    associatedtype State
    var isViewLoaded: Bool { get }
    func update(state: State, oldState: State?)
    func showError(_ error: Error)
    
}

public extension ViewType where Self: UIViewController {
    
    func showError(_ error: Error) {
        self.showAlert(errorMessage: error.localizedDescription)
    }
}
