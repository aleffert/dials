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
    
    @IBOutlet var propertyTableController : ViewAdjustPropertyTableController?
    @IBOutlet var outlineController : ViewAdjustHierarchyOutlineController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outlineController?.delegate = self
        propertyTableController?.delegate = self
    }
    
    func receivedHierarchy(hierarchy : [NSString : DLSViewHierarchyRecord], roots : [NSString]) {
        outlineController?.useHierarchy(hierarchy, roots : roots)
    }
    
    func receivedViewRecord(record : DLSViewRecord) {
        propertyTableController?.useRecord(record)
    }
    
    func receivedUpdatedViews(records : [DLSViewHierarchyRecord], roots : [NSString]) {
        outlineController?.takeUpdateRecords(records, roots : roots)
        if !(outlineController?.hasSelection ?? false) {
            propertyTableController?.clear()
        }
    }
    
    func outlineController(controller: ViewAdjustHierarchyOutlineController, selectedViewWithID viewID: NSString?) {
        delegate?.viewAdjustController(self, selectedViewWithID: viewID)
    }
    
    func tableController(controller: ViewAdjustPropertyTableController, valueChangedWithRecord record : DLSChangeViewValueRecord) {
        delegate?.viewAdjustController(self, valueChangedWithRecord: record)
    }
}
