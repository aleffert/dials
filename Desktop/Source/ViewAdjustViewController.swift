//
//  ViewAdjustViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

class ViewAdjustViewController: NSViewController {
    
    @IBOutlet weak var visualContainer : NSView?
    @IBOutlet weak var outlineContainer : NSView?
    @IBOutlet weak var dialsContainer : NSView?
    
    @IBOutlet weak var outlineView : NSOutlineView?
    
    let outlineController = ViewHierarchyOutlineController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outlineView?.setDataSource(outlineController)
        outlineView?.setDelegate(outlineController)
    }
    
    func receivedHierarchy(hierarchy : NSArray) {
        outlineController.useHierarchy(hierarchy)
        outlineView?.reloadData()
    }
}
