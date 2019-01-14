//
//  Permissions.swift
//  Swifty
//
//  Created by Vadim Pavlov on 8/17/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

public enum Permissions {

    public typealias RequestCompletion = () -> Void

    public static let photos = Photos()
    public static let location = Location()
    public static let notifications = Notifications()
}

public protocol Permission {
    func showSettingsAlert(permission: String, in vc: UIViewController)
}

public extension Permission {

    func validate(usageKey: String) -> Bool {
        let object = Bundle.main.object(forInfoDictionaryKey: usageKey)
        assert(object != nil, "\(usageKey) not found in Info.plist")
        return object != nil
    }

    func showSettingsAlert(permission: String, in vc: UIViewController) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

        let title = "Permission for \(permission) was denied"
        let message = "Please enable access to \(permission) in the Settings app."

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

        alert.addAction(cancel)
        alert.addAction(settings)
        vc.present(alert, animated: true, completion: nil)
    }
}
