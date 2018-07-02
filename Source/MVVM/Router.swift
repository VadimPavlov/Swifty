//
//  Router.swift
//  Created by Vadim Pavlov on 2/22/17.

import UIKit

// https://github.com/mac-cain13/R.swift
@available(*, deprecated, message: "Use R.swift for strong typed segues")
public protocol Router {
    associatedtype Segue: RawRepresentable
    func performSegue(_ segue: Segue, sender: Any?)
    func prepareSegue(_ segue: Segue, destination: UIViewController, sender: Any?)
}

public extension Router where Segue.RawValue == String, Self: UIViewController {

    func performSegue(_ segue: Segue, sender: Any?) {
        let identifier = segue.rawValue
        if shouldPerformSegue(withIdentifier: identifier, sender: sender) {
            performSegue(withIdentifier: identifier, sender: sender)
        }
    }

    func prepare(storyboardSegue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = storyboardSegue.identifier else { return }
        let destination = storyboardSegue.destination

        if let segue = Segue(rawValue: identifier) {
            self.prepareSegue(segue, destination: destination, sender: sender)
        } else {
            assertionFailure("Invalid identifier: \(identifier)")
        }
    }
}
