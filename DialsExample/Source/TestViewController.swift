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

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        DLSGroupWithName("Swift Test Group") { control in
            DLSControl(keyPath: "view.backgroundColor")
            DLSControl("example").sliderOf(&foo)
            DLSControl("some color").colorOf(&color)
            DLSControl("set color").actionOf {
                self.view.backgroundColor = self.color
            }
        }
    }
    
    var color : UIColor? = UIColor(red:0.99, green:0.22, blue:0.3, alpha:1)

}
