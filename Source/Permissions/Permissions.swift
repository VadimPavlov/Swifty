//
//  Permissions.swift
//  Swifty
//
//  Created by Vadim Pavlov on 8/17/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

enum Permissions {

    static let location = Location()
    static let notifications = Notifications()
    static let photos = Photos()

    typealias RequestCompletion = () -> Void

}


protocol Permission {
    func showSettingsAlert(permission: String, in vc: UIViewController)
}

extension Permission {

    func validate(usageKey: String) -> Bool {
        let object = Bundle.main.object(forInfoDictionaryKey: usageKey)
        assert(object == nil, "\(usageKey) not found in Info.plist")
        return object != nil
    }

    func showSettingsAlert(permission: String, in vc: UIViewController) {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }

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
