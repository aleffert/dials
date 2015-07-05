//
//  TestViewController.swift
//  DialsExample
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit
import Dials

var sliderValue : CGFloat = 0.74
var color : UIColor = UIColor(red:0.99, green:0.22, blue:0.3, alpha:1)

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        DLSGroupWithName("Example Group (Swift)") {
            DLSControl(keyPath: "view.backgroundColor")
            DLSControl("Example Slider").sliderOf(&sliderValue)
            
            DLSControl("Some Color").colorOf(&color)
            
            DLSControl("Set Color as Background").actionOf {
                self.view.backgroundColor = color
            }
            
            DLSControl("Add Toolbar Button").actionOf {
                var items = self.toolbarItems ?? []
                items.append(UIBarButtonItem(title: "Item", style: .Plain, target: nil, action: nil))
                self.toolbarItems = items
            }
        }
    }
    

}
