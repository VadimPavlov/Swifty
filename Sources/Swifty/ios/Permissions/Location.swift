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
        public var nameInUse = "Location In Use"
        public var nameAlways = "Location Always"

        public lazy var status = Observable<CLAuthorizationStatus>(CLLocationManager.authorizationStatus())

        private let manager = CLLocationManager()
        private var completion: RequestCompletion?

        override init() {
            super.init()
            manager.delegate = self
        }

        public func requestAlways(from vc: UIViewController, completion: RequestCompletion? = nil) {
            guard validate(usageKey: "NSLocationAlwaysUsageDescription") else { return }

            switch status.value {
            case .authorizedAlways:
                completion?()
            case .notDetermined:
                self.completion = completion
                self.manager.requestAlwaysAuthorization()
            default:
                self.showSettingsAlert(permission: nameAlways, in: vc)
            }
        }

        public func requestWhenInUse(from vc: UIViewController, completion: RequestCompletion? = nil) {
            guard validate(usageKey: "NSLocationWhenInUseUsageDescription") else { return }

            switch status.value {
            case .authorizedWhenInUse, .authorizedAlways:
                completion?()
            case .notDetermined:
                self.completion = completion
                self.manager.requestWhenInUseAuthorization()
            default:
                self.showSettingsAlert(permission: nameInUse, in: vc)
                completion?()
            }
        }

        public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .notDetermined { return }
            self.status.value = status
            completion?()
            completion = nil
        }
    }
}
