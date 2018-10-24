//
//  Keyboard.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

public typealias KeyboardAnimation = (KeyboardUserInfo) -> Void

public enum Keyboard {
    public static let WillShowNotification    = NotificationDescriptor(name: UIResponder.keyboardWillShowNotification, convert: KeyboardUserInfo.init)
    public static let DidShowNotification     = NotificationDescriptor(name: UIResponder.keyboardDidShowNotification,  convert: KeyboardUserInfo.init)
    public static let WillHideNotification    = NotificationDescriptor(name: UIResponder.keyboardWillHideNotification, convert: KeyboardUserInfo.init)
    public static let DidHideNotification     = NotificationDescriptor(name: UIResponder.keyboardDidHideNotification,  convert: KeyboardUserInfo.init)

    public static func animate(with info: KeyboardUserInfo, animation: @escaping KeyboardAnimation) {

        guard let curve = UIView.AnimationCurve(rawValue: info.animationCurve) else { return }
        let duration = info.animationDuration

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        UIView.setAnimationBeginsFromCurrentState(true)
        animation(info)
        UIView.commitAnimations()
    }
}

public struct KeyboardUserInfo {
    public let isLocalUser: Bool
    
    public let frameBeginUser: CGRect
    public let frameEndUser: CGRect
    
    public let animationDuration: TimeInterval
    public let animationCurve: Int
    
    public var deltaY: CGFloat {
        return frameBeginUser.minY - frameEndUser.minY
    }
}

fileprivate extension KeyboardUserInfo {
    init(notification: Notification) {
        let userInfo = notification.userInfo
        
        isLocalUser = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
        
        frameBeginUser = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        frameEndUser = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        animationDuration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        animationCurve = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int
    }
}

public struct KeyboardNotificationToken {
    public let show: NotificationToken
    public let hide: NotificationToken
    
    public init(show: NotificationToken, hide: NotificationToken) {
        self.show = show
        self.hide = hide
    }
}

public extension UIScrollView {
    
    public struct OriginalInsets {
        let contentBottom: CGFloat
        let indicatorsBottom: CGFloat
    }

    func observeKeyboardNotifications(center: NotificationCenter = .default, extraInset: CGFloat = 0, animate: KeyboardAnimation? = nil) -> KeyboardNotificationToken {
        
        let original = OriginalInsets(contentBottom: self.contentInset.bottom, indicatorsBottom: self.scrollIndicatorInsets.bottom)
        
        let showToken = center.addObserver(descriptor: Keyboard.WillShowNotification) { info in
            guard let scrollRect = self.window?.convert(self.frame, from: self.superview) else { return }

            let keyboardFrame = info.frameEndUser
            let overlaped = keyboardFrame.intersection(scrollRect)
            
            // window orientation depended
            let inset = overlaped.minX == 0 ? overlaped.height : overlaped.width
            
            self.contentInset.bottom = inset + extraInset
            self.scrollIndicatorInsets.bottom = inset + extraInset
            
            if let animation = animate {
                Keyboard.animate(with: info, animation: animation)
            }
        }
        
        let hideToken = center.addObserver(descriptor: Keyboard.WillHideNotification) { info in
            self.contentInset.bottom = original.contentBottom
            self.scrollIndicatorInsets.bottom = original.indicatorsBottom
            
            if let animation = animate {
                Keyboard.animate(with: info, animation: animation)
            }
        }
        
        return KeyboardNotificationToken(show: showToken, hide: hideToken)
    }
}
