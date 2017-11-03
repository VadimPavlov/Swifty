//
//  Router.swift
//  Created by Vadim Pavlov on 2/22/17.

import UIKit

public protocol Router {
    associatedtype Segue: RawRepresentable
    weak var source: UIViewController? { get }

    func performSegue(_ segue: Segue, sender: Any?)
    func onSegue(segue: Segue, destination: UIViewController, sender: Any?)
    
    func onSegue(storyboardSegue: UIStoryboardSegue, sender: Any?)

}

public extension Router where Segue.RawValue == String {
    
    public func performSegue(_ segue: Segue, sender: Any?) {
        let identifier = segue.rawValue
        let shouldPerform = source?.shouldPerformSegue(withIdentifier: identifier, sender: sender) ?? true
        if shouldPerform {
            source?.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    public func onSegue(storyboardSegue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = storyboardSegue.identifier else { return }
        let destination = storyboardSegue.destination
        
        if let segue = Segue(rawValue: identifier) {
            self.onSegue(segue: segue, destination: destination, sender: sender)
        } else {
            assertionFailure("Invalid identifier: \(identifier)")
        }
        
    }
}
