//
//  UIScrollView.swift
//  Created by Vadim Pavlov on 5/6/16.

import UIKit

public extension UIScrollView {
    
    public func subscribeForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIScrollView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIScrollView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    public func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    public func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.CGRectValue()
            if let scrollRect = self.window?.convertRect(self.frame, fromView: self.superview) {
                let intersection = CGRectIntersection(keyboardFrame, scrollRect)
                let intersectionInset = keyboardFrame.origin.x == 0 ? intersection.height : intersection.width // orientation checking
                
                var inset = self.contentInset
                inset.bottom = intersectionInset
                self.contentInset = inset
                self.scrollIndicatorInsets = inset
            }
        }
    }
    public func keyboardWillHide(notification: NSNotification) {
        var inset = self.contentInset
        inset.bottom = 0
        self.contentInset = inset
        self.scrollIndicatorInsets = inset
        
    }
}