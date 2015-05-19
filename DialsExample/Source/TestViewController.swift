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
    
    var color : UIColor = UIColor.grayColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        DLSLiveDialsPlugin.activePlugin()?.groupWithName("Swift Test Group") {
            self.DLSControl("perform").actionOf { _ in
                NSLog("performed")
            }
            self.DLSControl(keyPath: "view.backgroundColor")
            self.DLSControl("example").sliderOf(&foo)
        }
    }

}
