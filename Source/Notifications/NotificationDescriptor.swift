//
//  NotificationToken.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

public struct NotificationDescriptor<A> {
    let name: Notification.Name
    let convert: (Notification) -> A
    
    public init(name: Notification.Name, convert: @escaping (Notification) -> A) {
        self.name = name
        self.convert = convert
    }
}

public struct CustomNotificationDescriptor<A> {
    let name: Notification.Name
    
    public init(name: Notification.Name) {
        self.name = name
    }
}

public extension NotificationCenter {
    func addObserver<A>(descriptor: NotificationDescriptor<A>, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (A) -> Void) -> NotificationToken {
        let token = self.addObserver(forName: descriptor.name, object: object, queue: queue) { notification in
            block(descriptor.convert(notification))
        }
        return NotificationToken(token: token, center: self)
    }
    
    func addObserver<A>(descriptor: CustomNotificationDescriptor<A>, object: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (A) -> Void) -> NotificationToken {
        let token = self.addObserver(forName: descriptor.name, object: object, queue: queue) { notification in
            block(notification.object as! A)
        }
        return NotificationToken(token: token, center: self)
    }
    
    func post<A>(descriptor: CustomNotificationDescriptor<A>, value: A) {
        post(name: descriptor.name, object: value)
    }
}

public struct NoUserInfo {
    public init(notification: Notification) {}
}
