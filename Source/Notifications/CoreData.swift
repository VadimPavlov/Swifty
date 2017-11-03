//
//  CoreData.swift
//  Swifty
//
//  Created by Vadim Pavlov on 10/24/17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import CoreData

public enum CoreData {
    public static let ContextWillSaveNotification = NotificationDescriptor(name: .NSManagedObjectContextWillSave, convert: NoUserInfo.init)
    public static let ContextDidSaveNotification = NotificationDescriptor(name: .NSManagedObjectContextDidSave, convert: ContextUserInfo.init)
    public static let ContextObjectsDidChangeNotification = NotificationDescriptor(name: .NSManagedObjectContextObjectsDidChange, convert: ContextUserInfo.init)
}

public struct ContextUserInfo {
    fileprivate let notification: Notification
    
    public let inserted: Set<NSManagedObject>?
    public let updated: Set<NSManagedObject>?
    public let deleted: Set<NSManagedObject>?
}

private extension ContextUserInfo {
    init(notification: Notification) {
        self.notification = notification
        
        let userInfo = notification.userInfo
        inserted = userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>
        updated = userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>
        deleted = userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>
    }
}

public extension NSManagedObjectContext {
    func merge(with context: NSManagedObjectContext, center: NotificationCenter = .default) -> NotificationToken {
        return center.addObserver(descriptor: CoreData.ContextDidSaveNotification, object: context) { [weak self] info in
            self?.perform {
                self?.mergeChanges(fromContextDidSave: info.notification)
            }
        }
    }
}
