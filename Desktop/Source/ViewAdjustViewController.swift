//
//  ViewAdjustViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

protocol ViewAdjustViewControllerDelegate : class {
    func viewAdjustController(controller : ViewAdjustViewController, selectedViewWithID viewID : NSString?)
    func viewAdjustController(controller : ViewAdjustViewController, valueChangedWithRecord record : DLSChangeViewValueRecord)
}

class ViewAdjustViewController: NSViewController, ViewAdjustHierarchyOutlineControllerDelegate, ViewAdjustPropertyTableControllerDelegate {
    
    weak var delegate : ViewAdjustViewControllerDelegate?
    
    @IBOutlet var propertyTableController : ViewAdjustPropertyTableController!
    @IBOutlet var hierarchyOutlineController : ViewAdjustHierarchyOutlineController!
    @IBOutlet var visualOutlineController : ViewAdjustVisualOutlineController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hierarchyOutlineController.delegate = self
        propertyTableController.delegate = self
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
    
    func outlineController(controller: ViewAdjustHierarchyOutlineController, selectedViewWithID viewID: NSString?) {
        delegate?.viewAdjustController(self, selectedViewWithID: viewID)
    }
    
    func tableController(controller: ViewAdjustPropertyTableController, valueChangedWithRecord record : DLSChangeViewValueRecord) {
        delegate?.viewAdjustController(self, valueChangedWithRecord: record)
    }
}
