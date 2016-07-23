//
//  UIAlertController.swift
//  Created by Vadim Pavlov on 4/15/16.

import UIKit

public extension UIAlertController {
    
    // Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior
    // http://stackoverflow.com/a/33944376
    
    convenience init(errorMessage: String, errorTitle: String? = nil) {
        let title = errorTitle ?? NSLocalizedString("Error", comment: "")
        let button = NSLocalizedString("Ok", comment: "")
        let cancel = UIAlertAction(title: button, style: .Cancel, handler: nil)
        
        self.init(title: title, message: errorMessage, preferredStyle: .Alert)
        self.addAction(cancel)
    }
    
    convenience init(error: NSError) {
        let message = error.localizedFailureReason ?? error.localizedDescription
        self.init(errorMessage: message)
    }
}