//
//  ExampleKeyboardViewController.swift
//  Example
//
//  Created by Vadim Pavlov on 11/15/18.
//  Copyright © 2018 Vadym Pavlov. All rights reserved.
//

import UIKit

final class ExampleKeyboardViewController: UIViewController {

    @IBOutlet var buyButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var canBecomeFirstResponder: Bool {
        return true
    }


    override var inputAccessoryView: UIView? {
        return buyButton.superview
    }


}
