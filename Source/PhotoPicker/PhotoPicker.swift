//
//  PhotoPicker.swift
//  FunMiles
//
//  Created by Vadim Pavlov on 10/10/17.
//  Copyright © 2017 MobileStrategy. All rights reserved.
//

import UIKit

public typealias PhotoPickCompletion = (UIImage?) -> Void

final public class PhotoPicker {
 
    public static func present(in viewController: PhotoPickerDelegate, allowsEditing: Bool = true, completion: @escaping PhotoPickCompletion) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { _ in
            presentPicker(sourceType: .camera, in: viewController, allowsEditing: allowsEditing, completion: completion)
        }
        
        let library = UIAlertAction(title: NSLocalizedString("Library", comment: ""), style: .default) { _ in
            presentPicker(sourceType: .photoLibrary, in: viewController, allowsEditing: allowsEditing, completion: completion)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        viewController.present(sheet, animated: true, completion: nil)
    }
    
    static func presentPicker(sourceType: UIImagePickerControllerSourceType, in viewController: PhotoPickerDelegate, allowsEditing: Bool, completion: @escaping PhotoPickCompletion) {
        let picker = ImagePickerController()
        picker.allowsEditing = allowsEditing
        picker.sourceType = sourceType
        picker.delegate = viewController
        picker.completion = completion
        viewController.present(picker, animated: true, completion: nil)
    }
}

final class ImagePickerController: UIImagePickerController {
    var completion: PhotoPickCompletion?
}
