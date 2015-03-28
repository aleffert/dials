//
//  TestViewController.swift
//  DialsExample
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit
import Dials

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        DLSLiveDialsPlugin.sharedPlugin().beginGroupWithName("Swift!")
        
        AddAction("perform", { () -> () in
            NSLog("performed")
        }, owner: self)
        AddColorControl(keyPath: "view.backgroundColor", self)
        DLSLiveDialsPlugin.sharedPlugin().endGroup()
    }

}
