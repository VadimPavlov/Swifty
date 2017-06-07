//
//  EventsViewController.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public struct ViewEvents {
    public let onDidLoad: () -> Void
    public let onPrepareSegue: (UIStoryboardSegue, Any?) -> Void
}

open class EventsViewController: UIViewController {
    public var viewEvents: ViewEvents?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.viewEvents?.onDidLoad()
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        self.viewEvents?.onPrepareSegue(segue, sender)
    }
}
