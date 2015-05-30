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
        
        DLSGroupWithName("Swift Test Group") {
            DLSControl(keyPath: "view.backgroundColor")
            DLSControl("Example Slider").sliderOf(&foo)
            
            DLSControl("Some Color").colorOf(&color)
            
            DLSControl("Set Color as Background").actionOf {
                self.view.backgroundColor = self.color
            }
        }
    }
    
    var color : UIColor = UIColor(red:0.99, green:0.22, blue:0.3, alpha:1)

}
