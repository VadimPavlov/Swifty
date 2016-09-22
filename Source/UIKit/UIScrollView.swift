//
//  UIScrollView.swift
//  Created by Vadim Pavlov on 5/6/16.

import UIKit

public extension UIScrollView {
    
    public func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIScrollView.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIScrollView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrameValue = (notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            if let scrollRect = self.window?.convert(self.frame, from: self.superview) {
                let intersection = keyboardFrame.intersection(scrollRect)
                let intersectionInset = keyboardFrame.origin.x == 0 ? intersection.height : intersection.width // orientation checking
                
                var inset = self.contentInset
                inset.bottom = intersectionInset
                self.contentInset = inset
                self.scrollIndicatorInsets = inset
            }
        }
    }
    public func keyboardWillHide(_ notification: Notification) {
        var inset = self.contentInset
        inset.bottom = 0
        self.contentInset = inset
        self.scrollIndicatorInsets = inset
        
    }
}
