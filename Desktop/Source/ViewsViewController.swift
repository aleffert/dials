//
//  ViewsViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

protocol ViewsViewControllerDelegate : class {
    func ViewsController(controller : ViewsViewController, selectedViewWithID viewID : NSString?)
    func ViewsController(controller : ViewsViewController, valueChangedWithRecord record : DLSChangeViewValueRecord)
}

class ViewsViewController: NSViewController, ViewHierarchyOutlineControllerDelegate, ViewPropertyTableControllerDelegate, ViewsVisualOutlineControllerDelegate {
    
    weak var delegate : ViewsViewControllerDelegate?
    
    @IBOutlet var propertyTableController : ViewPropertyTableController!
    @IBOutlet var hierarchyOutlineController : ViewsHierarchyOutlineController!
    @IBOutlet var visualOutlineController : ViewsVisualOutlineController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hierarchyOutlineController.delegate = self
        propertyTableController.delegate = self
        visualOutlineController.delegate = self
        visualOutlineController.hierarchy = hierarchyOutlineController.hierarchy
    }
    
    func receivedHierarchy(hierarchy : [NSString : DLSViewHierarchyRecord], roots : [NSString], screenSize : CGSize) {
        hierarchyOutlineController.useHierarchy(hierarchy, roots : roots)
        visualOutlineController.updateViews()
        visualOutlineController.screenSize = screenSize
    }
    
    func receivedViewRecord(record : DLSViewRecord) {
        propertyTableController?.useRecord(record)
    }
    
    func receivedUpdatedViews(records : [DLSViewHierarchyRecord], roots : [NSString], screenSize : CGSize) {
        hierarchyOutlineController.takeUpdateRecords(records, roots : roots)
        if !hierarchyOutlineController.hasSelection {
            propertyTableController.clear()
        }
        visualOutlineController.updateViews()
        visualOutlineController.screenSize = screenSize
    }
    
    func receivedContents(contents : [NSString:NSData], empties:[NSString]) {
        visualOutlineController.takeContents(contents, empties : empties)
    }
    
    func outlineController(controller: ViewsHierarchyOutlineController, selectedViewWithID viewID: NSString?) {
        delegate?.ViewsController(self, selectedViewWithID: viewID)
        visualOutlineController.selectViewWithID(viewID)
    }
    
    func visualOutlineController(controller: ViewsVisualOutlineController, selectedViewWithID viewID: NSString?) {
        hierarchyOutlineController.selectViewWithID(viewID)
    }
    
    func tableController(controller: ViewPropertyTableController, valueChangedWithRecord record : DLSChangeViewValueRecord) {
        delegate?.ViewsController(self, valueChangedWithRecord: record)
    }
}
