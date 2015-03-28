//
//  TestViewController.swift
//  DialsExample
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit
import Dials

var foo : Float = .5

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        DLSLiveDialsPlugin.sharedPlugin().beginGroupWithName("Swift!")
        
        DLSAddAction("perform", { () -> () in
            NSLog("performed")
        }, owner: self)
        DLSAddColorControl(keyPath: "view.backgroundColor", self)
        DLSAddSliderControl("example", &foo, owner: self)
        DLSLiveDialsPlugin.sharedPlugin().endGroup()
    }

}
