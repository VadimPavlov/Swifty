//
//  Keyboard.swift
//  Swifty
//
//  Created by Vadym Pavlov on 12.05.17.
//  Copyright © 2017 Vadym Pavlov. All rights reserved.
//

import UIKit

enum Keyboard {
    static let WillShowNotification    = NotificationDescriptor(name: .UIKeyboardWillShow, convert: KeyboardUserInfo.init)
    static let DidShowNotification     = NotificationDescriptor(name: .UIKeyboardDidShow,  convert: KeyboardUserInfo.init)
    static let WillHideNotification    = NotificationDescriptor(name: .UIKeyboardWillHide, convert: KeyboardUserInfo.init)
    static let DidHideNotification     = NotificationDescriptor(name: .UIKeyboardDidHide,  convert: KeyboardUserInfo.init)
}

public struct KeyboardUserInfo {
    let isLocalUser: Bool
    
    let frameBeginUser: CGRect
    let frameEndUser: CGRect
    
    let animationDuration: TimeInterval
    let animationCurve: Int
}

fileprivate extension KeyboardUserInfo {
    init(notification: Notification) {
        let userInfo = notification.userInfo
        
        isLocalUser = userInfo?[UIKeyboardIsLocalUserInfoKey] as! Bool
        
        frameBeginUser = userInfo?[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        frameEndUser = userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        animationDuration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        animationCurve = userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! Int
    }
}

public struct KeyboardNotificationToken {
    let show: NotificationToken
    let hide: NotificationToken
}

public extension UIScrollView {
    
    struct OriginalInsets {
        let contentBottom: CGFloat
        let indicatorsBottom: CGFloat
    }
    
    typealias KeyboardAnimation = (KeyboardUserInfo) -> Void
    
    func observeKeyboardNotifications(center: NotificationCenter = .default, animate: KeyboardAnimation? = nil) -> KeyboardNotificationToken {
        
        let original = OriginalInsets(contentBottom: self.contentInset.bottom, indicatorsBottom: self.scrollIndicatorInsets.bottom)
        
        let showToken = center.addObserver(descriptor: Keyboard.WillShowNotification) { info in
            guard let scrollRect = self.window?.convert(self.frame, from: self.superview) else { return }

            let keyboardFrame = info.frameEndUser
            let overlaped = keyboardFrame.intersection(scrollRect)
            
            // window orientation depended
            let inset = overlaped.minX == 0 ? overlaped.height : overlaped.width
            
            self.contentInset.bottom = inset
            self.scrollIndicatorInsets.bottom = inset
            
            if let animation = animate {
                self.animate(with: info, animation: animation)
            }
        }
        
        let hideToken = center.addObserver(descriptor: Keyboard.WillHideNotification) { info in
            self.contentInset.bottom = original.contentBottom
            self.scrollIndicatorInsets.bottom = original.indicatorsBottom
            
            if let animation = animate {
                self.animate(with: info, animation: animation)
            }
        }
        
        return KeyboardNotificationToken(show: showToken, hide: hideToken)
    }
    
    
    private func animate(with info: KeyboardUserInfo, animation: @escaping KeyboardAnimation) {
        
        guard let curve = UIViewAnimationCurve(rawValue: info.animationCurve) else { return }
        let duration = info.animationDuration
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(curve)
        UIView.setAnimationBeginsFromCurrentState(true)
        animation(info)
        UIView.commitAnimations()
        
    }
}
