//
//  TestViewController.swift
//  DialsExample
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit
import Dials

var color = UIColor(red:0.17, green:0.72, blue:1, alpha:1)
var buttonTitle = "Better Title"

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        DLSGroupWithName("Example Group (Swift)") {
            DLSControl("Some Color").colorOf(&color)
            
            _ = DLSControl("Set Color as Background").actionOf {[weak self] in
                self?.view.backgroundColor = color
            }

            _ = DLSControl("Add Toolbar Button").actionOf {[weak self] in
                var items = self?.toolbarItems ?? []
                items.append(UIBarButtonItem(title: buttonTitle, style: .plain, target: nil, action: nil))
                self?.toolbarItems = items
            }

            DLSControl("Button Title").textFieldOf(&buttonTitle)
            
        }
    }
    
    deinit {
        print("clearing")
    }
    

}
