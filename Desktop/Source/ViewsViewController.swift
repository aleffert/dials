//
//  ViewsViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/2/15.
//
//

import Cocoa

protocol ViewsViewControllerDelegate : class {
    func viewsController(_ controller : ViewsViewController, selectedViewWithID viewID : String?)
    func viewsController(_ controller : ViewsViewController, valueChangedWithRecord record : DLSChangeViewValueRecord)
    func viewController(_ controller : ViewsViewController, appliedInsets : EdgeInsets, toViewWithID viewID : String)
}

class ViewsViewController: NSViewController,
ViewHierarchyOutlineControllerDelegate,
ViewPropertyTableControllerDelegate,
ViewsVisualOutlineControllerDelegate,
ConstraintInfoOwner {
    
    weak var delegate : ViewsViewControllerDelegate?
    weak var constraintInfoSource : ConstraintInfoSource?
    
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
    
    func receivedHierarchy(_ hierarchy : [String : DLSViewHierarchyRecord], roots : [String], screenSize : CGSize) {
        hierarchyOutlineController.useHierarchy(hierarchy, roots : roots)
        visualOutlineController.updateViews()
        visualOutlineController.screenSize = screenSize
    }
    
    func receivedViewRecord(_ record : DLSViewRecord) {
        propertyTableController?.useRecord(record)
    }
    
    func receivedUpdatedViews(_ records : [DLSViewHierarchyRecord], roots : [String], screenSize : CGSize) {
        hierarchyOutlineController.takeUpdateRecords(records, roots : roots)
        if !hierarchyOutlineController.hasSelection {
            propertyTableController.clear()
        }
        visualOutlineController.updateViews()
        visualOutlineController.screenSize = screenSize
    }
    
    func receivedContents(_ contents : [String:Data], empties:[String]) {
        visualOutlineController.takeContents(contents, empties : empties)
    }
    
    func outlineController(_ controller: ViewsHierarchyOutlineController, selectedViewWithID viewID: String?) {
        delegate?.viewsController(self, selectedViewWithID: viewID)
        visualOutlineController.selectViewWithID(viewID)
    }
    
    func visualOutlineController(_ controller: ViewsVisualOutlineController, selectedViewWithID viewID: String?) {
        hierarchyOutlineController.selectViewWithID(viewID)
    }
    
    func visualOutlineController(_ controller: ViewsVisualOutlineController, appliedInsets insets: EdgeInsets, toViewWithID viewID: String) {
        delegate?.viewController(self, appliedInsets: insets, toViewWithID: viewID)
    }
    
    func tableController(_ controller: ViewPropertyTableController, valueChangedWithRecord record : DLSChangeViewValueRecord) {
        delegate?.viewsController(self, valueChangedWithRecord: record)
    }
    
    func tableController(_ controller: ViewPropertyTableController, highlightViewWithID viewID: String) {
        visualOutlineController.highlightViewWithID(viewID)
    }
    
    func tableController(_ controller: ViewPropertyTableController, clearHighlightForViewWithID viewID: String) {
        visualOutlineController.unhighlightViewWithID(viewID)
    }
    
    func tableController(_ controller: ViewPropertyTableController, selectViewWithID viewID: String) {
        visualOutlineController.highlightViewWithID(nil)
        hierarchyOutlineController.selectViewWithID(viewID)
        delegate?.viewsController(self, selectedViewWithID: viewID)
    }
    
    func tableController(_ controller: ViewPropertyTableController, nameOfConstraintWithInfo info: DLSAuxiliaryConstraintInformation) -> String? {
        guard let plugin = self.constraintInfoSource?.constraintSources.filter({$0.identifier == info.pluginIdentifier }).first else {
            print("Plugin not found: \(info.pluginIdentifier)")
            return nil
        }
        return plugin.displayName(ofConstraint: info)
    }
    
    func tableController(_ controller: ViewPropertyTableController, saveConstraintWithInfo info: DLSAuxiliaryConstraintInformation, constant: CGFloat) {
        guard let plugin = self.constraintInfoSource?.constraintSources.filter({$0.identifier == info.pluginIdentifier }).first else {
            showSaveError("Plugin not found: " + info.pluginIdentifier)
            return
        }
        do {
            try plugin.saveConstraint(info, constant: constant)
        }
        catch let e as NSError {
            showSaveError(e.localizedDescription)
        }
    }
    
    func showSaveError(_ message : String) {
        let alert = NSAlert()
        alert.messageText = "Error Updating Code"
        alert.informativeText = message
        alert.addButton(withTitle: "Okay")
        alert.runModal()
    }
}
