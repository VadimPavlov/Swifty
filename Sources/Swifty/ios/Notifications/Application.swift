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
    public static let WillEnterForeground = NotificationDescriptor(name: UIApplication.willEnterForegroundNotification, convert: NoUserInfo.init)
    public static let DidEnterBackground = NotificationDescriptor(name: UIApplication.didEnterBackgroundNotification, convert: NoUserInfo.init)
    public static let WillTerminate = NotificationDescriptor(name: UIApplication.willTerminateNotification, convert: NoUserInfo.init)
    
    // Focus
    public static let WillResignActive = NotificationDescriptor(name: UIApplication.willResignActiveNotification, convert: NoUserInfo.init)
    public static let DidBecomeActive = NotificationDescriptor(name: UIApplication.didBecomeActiveNotification, convert: NoUserInfo.init)
}
