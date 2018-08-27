//
//  EventsViewController.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

@available(*, deprecated, message: "Use R.swift for strong typed segues")
public struct ViewEvents {
    
    public typealias DidLoadAction = () -> Void
    public typealias SegueAction = (UIStoryboardSegue, Any?) -> Void
    
    public let onDidLoad: DidLoadAction?
    public let onSegue: SegueAction?
    
    public init(onDidLoad: DidLoadAction? = nil, onSegue: SegueAction? = nil) {
        self.onDidLoad = onDidLoad
        self.onSegue = onSegue
    }
}

@available(*, deprecated, message: "Use R.swift for strong typed segues")
open class EventsViewController: UIViewController {
    public var viewEvents: ViewEvents?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.viewEvents?.onDidLoad?()
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.viewEvents?.onSegue?(segue, sender)
    }
}

@available(*, deprecated, message: "Use R.swift for strong typed segues")
open class EventsTableViewController: UITableViewController {
    public var viewEvents: ViewEvents?

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.viewEvents?.onDidLoad?()
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.viewEvents?.onSegue?(segue, sender)
    }
}

@available(*, deprecated, message: "Use R.swift for strong typed segues")
open class EventsCollectionViewController: UICollectionViewController {
    public var viewEvents: ViewEvents?

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.viewEvents?.onDidLoad?()
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.viewEvents?.onSegue?(segue, sender)
    }
}
