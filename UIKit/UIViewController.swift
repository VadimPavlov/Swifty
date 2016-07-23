//
//  UIViewController.swift
//  SwiftCourse
//
//  Created by Vadim Pavlov on 4/12/16.
//  Copyright © 2016 DataArt. All rights reserved.
//

import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid segue identifier \(segue.identifier).") }
        return segueIdentifier
    }
}

extension UIViewController {
    func showErrorMessage(message: String) {
        let alert = UIAlertController(errorMessage: message)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func showError(error: NSError) {
        let alert = UIAlertController(error: error)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}