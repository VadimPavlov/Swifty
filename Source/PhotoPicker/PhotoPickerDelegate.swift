//
//  PhotoPickerDelegate.swift
//  FunMiles
//
//  Created by Vadim Pavlov on 10/10/17.
//  Copyright © 2017 MobileStrategy. All rights reserved.
//

import UIKit

public protocol PhotoPickerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: PhotoPickerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let edited = info[UIImagePickerControllerEditedImage] as? UIImage
        let original = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if  let image = edited ?? original, let picker = picker as? ImagePickerController {
            picker.completion?(image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
