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

extension NotificationCenter {
    func addObserver<A>(descriptor: NotificationDescriptor<A>, using block: @escaping (A) -> Void) -> NotificationToken {
        let token = self.addObserver(forName: descriptor.name, object: nil, queue: nil) { notification in
            block(descriptor.convert(notification))
        }
        return NotificationToken(token: token, center: self)
    }
}
