//
//  Application.swift
//  Swifty
//
//  Created by Vadim Pavlov on 10/31/17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public enum Application {
    
    // State
    public static let WillEnterForeground = NotificationDescriptor(name: .UIApplicationWillEnterForeground, convert: NoUserInfo.init)
    public static let DidEnterBackground = NotificationDescriptor(name: .UIApplicationDidEnterBackground, convert: NoUserInfo.init)
    public static let WillTerminate = NotificationDescriptor(name: .UIApplicationWillTerminate, convert: NoUserInfo.init)
    
    // Focus
    public static let WillResignActive = NotificationDescriptor(name: .UIApplicationWillResignActive, convert: NoUserInfo.init)
    public static let DidBecomeActive = NotificationDescriptor(name: .UIApplicationDidBecomeActive, convert: NoUserInfo.init)
}
