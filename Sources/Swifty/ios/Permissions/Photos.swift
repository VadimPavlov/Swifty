//
//  Photos.swift
//  Swifty
//
//  Created by Vadim Pavlov on 8/17/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import Photos
import UIKit

public extension Permissions {

    final class Photos: Permission {
        public var name = "Photos"
        public let status = Observable<PHAuthorizationStatus>(PHPhotoLibrary.authorizationStatus())

        public func request(from vc: UIViewController, completion: RequestCompletion? = nil) {
            guard validate(usageKey: "NSPhotoLibraryUsageDescription") else { return }

            switch status.value {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { status in
                    self.status.value = status
                    completion?()
                }
            case .authorized:
                completion?()
            default:
                showSettingsAlert(permission: name, in: vc)
            }
            
        }
    }
}
