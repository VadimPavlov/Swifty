//
//  MediaPicker.swift
//  FunMiles
//
//  Created by Vadim Pavlov on 10/10/17.
//  Copyright © 2017 MobileStrategy. All rights reserved.
//

import UIKit

public typealias MediaPickCompletion = (PickedMedia) -> Void
public typealias MediaPickerConfig = (UIImagePickerController) -> Void

public enum MediaPicker {
 
    public static func present(in viewController: MediaPickerDelegate,
                               cameraTitle: String = NSLocalizedString("Camera", comment: ""),
                               libraryTitle: String = NSLocalizedString("Library", comment: ""),
                               cancelTitle: String = NSLocalizedString("Cancel", comment: ""),
                               config: MediaPickerConfig? = nil,
                               completion: @escaping MediaPickCompletion) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: cameraTitle, style: .default) { _ in
            presentPicker(sourceType: .camera, in: viewController, config: config, completion: completion)
        }
        
        let library = UIAlertAction(title: libraryTitle, style: .default) { _ in
            presentPicker(sourceType: .photoLibrary, in: viewController, config: config, completion: completion)
        }
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        viewController.present(sheet, animated: true, completion: nil)
    }
    
    static func presentPicker(sourceType: UIImagePickerController.SourceType, in viewController: MediaPickerDelegate, config: MediaPickerConfig? = nil, completion: @escaping MediaPickCompletion) {
        let picker = MediaPickerController()
        picker.delegate = viewController
        picker.sourceType = sourceType
        picker.completion = completion
        config?(picker)
        viewController.present(picker, animated: true, completion: nil)
    }
}

final class MediaPickerController: UIImagePickerController {
    var completion: MediaPickCompletion?
}
