//
//  TestViewController.swift
//  DialsExample
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit
import Dials

var foo : CGFloat = 0.6
var color : UIColor = UIColor(white: 1, alpha: 1)

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        DLSGroupWithName("Swift Test Group") { control in
            DLSControl("perform").actionOf { _ in
                NSLog("performed")
            }
            DLSControl(keyPath: "view.backgroundColor")
            DLSControl("example").sliderOf(&foo)
            DLSControl("some color").colorOf(&color)
        }
    }

}
