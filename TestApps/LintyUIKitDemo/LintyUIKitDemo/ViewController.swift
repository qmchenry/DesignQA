//
//  ViewController.swift
//  LintyUIKitDemo
//
//  Created by Quinn McHenry on 5/22/20.
//  Copyright © 2020 Quinn McHenry. All rights reserved.
//

import UIKit
import UILint

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = UILint(view: view)
    }


}

