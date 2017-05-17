//
//  NotificationToken.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import Foundation

struct NotificationDescriptor<A> {
    let name: Notification.Name
    let convert: (Notification) -> A
}

struct CustomNotificationDescriptor<A> {
    let name: Notification.Name
}

extension NotificationCenter {
    func addObserver<A>(descriptor: NotificationDescriptor<A>, queue: OperationQueue? = nil, using block: @escaping (A) -> Void) -> NotificationToken {
        let token = self.addObserver(forName: descriptor.name, object: nil, queue: queue) { notification in
            block(descriptor.convert(notification))
        }
        return NotificationToken(token: token, center: self)
    }
    
    func addObserver<A>(descriptor: CustomNotificationDescriptor<A>, queue: OperationQueue? = nil, using block: @escaping (A) -> Void) -> NotificationToken {
        let token = self.addObserver(forName: descriptor.name, object: nil, queue: queue) { notification in
            block(notification.object as! A)
        }
        return NotificationToken(token: token, center: self)
    }
    
    func post<A>(descriptor: CustomNotificationDescriptor<A>, value: A) {
        post(name: descriptor.name, object: value)
    }
}
