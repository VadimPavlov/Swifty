//
//  Photos.swift
//  Swifty
//
//  Created by Vadim Pavlov on 8/17/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Photos
import Swifty

public extension Permissions {

    final class Photos: Permission {

        let status = Observable<PHAuthorizationStatus>(PHPhotoLibrary.authorizationStatus())

        func request(from vc: UIViewController, completion: RequestCompletion? = nil) {
            guard validate(usageKey: "NSLocationAlwaysUsageDescription") else { return }

            switch status.value {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    self.status.value = status
                    completion?()
                }
            case .authorized:
                completion?()
            default:
                showSettingsAlert(permission: "Photos", in: vc)
            }
            
        }
    }
}
