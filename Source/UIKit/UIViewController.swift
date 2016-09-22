//
//  UIViewController.swift
//  Created by Vadim Pavlov on 4/12/16.

import UIKit

public protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

public extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    public func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    public func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid segue identifier \(segue.identifier).") }
        return segueIdentifier
    }
}

extension UIViewController {
    public func showErrorMessage(_ message: String) {
        let alert = UIAlertController(errorMessage: message)
        self.present(alert, animated: true, completion: nil)
    }
    public func showError(_ error: NSError) {
        let alert = UIAlertController(error: error)
        self.present(alert, animated: true, completion: nil)
    }
}
