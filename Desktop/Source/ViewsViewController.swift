//
//  ViewsViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

protocol ViewsViewControllerDelegate : class {
    func viewsController(controller : ViewsViewController, selectedViewWithID viewID : String?)
    func viewsController(controller : ViewsViewController, valueChangedWithRecord record : DLSChangeViewValueRecord)
    func viewController(controller : ViewsViewController, appliedInsets : NSEdgeInsets, toViewWithID viewID : String)
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
        propertyTableController.hierarchy = hierarchyOutlineController.hierarchy
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
    
    func receivedContents(contents : [String:NSData], empties:[String]) {
        visualOutlineController.takeContents(contents, empties : empties)
    }
    
    func outlineController(controller: ViewsHierarchyOutlineController, selectedViewWithID viewID: String?) {
        delegate?.viewsController(self, selectedViewWithID: viewID)
        visualOutlineController.selectViewWithID(viewID)
    }
    
    func visualOutlineController(controller: ViewsVisualOutlineController, selectedViewWithID viewID: String?) {
        hierarchyOutlineController.selectViewWithID(viewID)
    }
    
    func visualOutlineController(controller: ViewsVisualOutlineController, appliedInsets insets: NSEdgeInsets, toViewWithID viewID: String) {
        delegate?.viewController(self, appliedInsets: insets, toViewWithID: viewID)
    }
    
    func tableController(controller: ViewPropertyTableController, valueChangedWithRecord record : DLSChangeViewValueRecord) {
        delegate?.viewsController(self, valueChangedWithRecord: record)
    }
}
