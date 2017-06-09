//
//  NotificationToken.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public class NotificationToken {
    public let token: NSObjectProtocol
    public let center: NotificationCenter
    
    public init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
        
    }
    deinit {
        center.removeObserver(token)
    }
}
