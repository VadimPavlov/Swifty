//
//  Location.swift
//  Swifty
//
//  Created by Vadim Pavlov on 8/17/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit
import CoreLocation

public extension Permissions {

    final class Location: NSObject, CLLocationManagerDelegate, Permission {

        let status = Observable<CLAuthorizationStatus>(CLLocationManager.authorizationStatus())

        private let manager = CLLocationManager()
        private var completion: RequestCompletion?

        override init() {
            super.init()
            manager.delegate = self
        }

        func requestAlways(from vc: UIViewController, completion: RequestCompletion? = nil) {
            guard validate(usageKey: "NSLocationAlwaysUsageDescription") else { return }

            switch status.value {
            case .authorizedAlways:
                completion?()
            case .notDetermined:
                self.completion = completion
                self.manager.requestAlwaysAuthorization()
            default:
                self.showSettingsAlert(permission: "Location Always", in: vc)
            }
        }

        func requestWhenInUse(from vc: UIViewController, completion: RequestCompletion? = nil) {
            guard validate(usageKey: "NSLocationWhenInUseUsageDescription") else { return }

            switch status.value {
            case .authorizedWhenInUse:
                completion?()
            case .notDetermined:
                self.completion = completion
                self.manager.requestWhenInUseAuthorization()
            default:
                self.showSettingsAlert(permission: "Location In Use", in: vc)
                completion?()
            }
        }

        private func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .notDetermined { return }
            self.status.value = status
            completion?()
            completion = nil
        }
    }
}
