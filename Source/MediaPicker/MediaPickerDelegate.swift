//
//  MediaPickerDelegate.swift
//  FunMiles
//
//  Created by Vadim Pavlov on 10/10/17.
//  Copyright © 2017 MobileStrategy. All rights reserved.
//

import UIKit

public protocol MediaPickerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

public struct PickedMedia {

    public let url: URL?
    public let type: String?
    public let original: UIImage?
    public let edited: UIImage?
    public let cropRect: CGRect?
    public let metadata: [String: Any]?

    init(info: [String: Any]) {
        type = info[UIImagePickerControllerMediaType] as? String
        edited = info[UIImagePickerControllerEditedImage] as? UIImage
        original = info[UIImagePickerControllerOriginalImage] as? UIImage
        cropRect = info[UIImagePickerControllerCropRect] as? CGRect
        metadata = info[UIImagePickerControllerMediaMetadata] as? [String: Any]

        // TODO: ensure urls correctness
        if #available(iOS 11.0, *) {
            url = info[UIImagePickerControllerImageURL] as? URL
//            let live = info[UIImagePickerControllerLivePhoto]
//            let asset = info[UIImagePickerControllerPHAsset]
        } else {
            url = info[UIImagePickerControllerReferenceURL] as? URL
        }
    }
}

extension UIViewController: MediaPickerDelegate {
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let picker = picker as? ImagePickerController {
            let photo = PickedMedia(info: info)
            picker.completion?(photo)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
