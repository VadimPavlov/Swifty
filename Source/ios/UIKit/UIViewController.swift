//
//  UIViewController.swift
//  Created by Vadim Pavlov on 4/12/16.

import UIKit

extension UIViewController {
    @objc @IBAction public func hideKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - Alerts
extension UIViewController {
    @objc open func showAlert(error: NSError) {
        let alert = UIAlertController(error: error)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc open func showAlert(errorMessage: String) {
        let alert = UIAlertController(errorMessage: errorMessage)
        self.present(alert, animated: true, completion: nil)
    }

}
