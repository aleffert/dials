//
//  ViewHierarchyOutlineController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/5/15.
//
//

import Cocoa

protocol ViewAdjustHierarchyOutlineControllerDelegate : class {
    func outlineController(controller : ViewAdjustHierarchyOutlineController, selectedViewWithID viewID: NSString?)
}

class ViewAdjustHierarchyOutlineController : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    @IBOutlet private var outlineView : NSOutlineView!
    weak var delegate : ViewAdjustHierarchyOutlineControllerDelegate?
    
    // NSOutlineView requires direct object identity so we need a way to convert
    // ids to a canonical representation
    // TODO: GC these
    var canonicalKeys : [NSString: NSString] = [:]
    
    let hierarchy = ViewAdjustHierarchy()
    
    private func canonicalize(value : NSString) -> NSString {
        if let canon = canonicalKeys[value] {
            return canon
        }
        else {
            canonicalKeys[value] = value
            return value
        }
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return hierarchy.roots.count
        }
        else {
            let record = hierarchy[item as! NSString]
            return record?.children.count ?? 0
        }
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            return canonicalize(hierarchy.roots[index])
        }
        else {
            let record = hierarchy[item as! NSString]
            let child = record?.children[index] as! NSString
            return canonicalize(child)
        }
    }

    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        let record = hierarchy[item as! NSString]
        return record.map {count($0.children) > 0} ?? false
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let cell = outlineView.makeViewWithIdentifier(tableColumn!.identifier!, owner: self) as! NSTableCellView
        
        let record = hierarchy[item as! NSString]
        record.map { cell.textField!.stringValue = $0.displayName }
        return cell
    }
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        let outlineView = notification.object as! NSOutlineView
        let selectionIndexes = outlineView.selectedRowIndexes
        if selectionIndexes.count == 0 {
            delegate?.outlineController(self, selectedViewWithID: nil)
        }
        else {
            let item = outlineView.itemAtRow(selectionIndexes.firstIndex) as! NSString
            delegate?.outlineController(self, selectedViewWithID: item)
        }
    }
    
    func useHierarchy(hierarchy : [NSString : DLSViewHierarchyRecord], roots : [NSString]) {
        self.hierarchy.map = hierarchy
        self.hierarchy.roots = roots
        outlineView.reloadData()
    }
    
    var hasSelection : Bool {
        return outlineView?.selectedRow != -1
    }
    
    func takeUpdateRecords(records : [DLSViewHierarchyRecord], roots : [NSString]) {
        self.hierarchy.roots = roots
        for record in records {
            hierarchy[record.viewID] = record
        }
        
        let selectedRow = outlineView!.selectedRow
        var selectedItem : NSString? = nil
        if selectedRow != -1 {
            selectedItem = outlineView.itemAtRow(selectedRow) as? NSString
        }
        
        outlineView.reloadData()
        
        if let item = selectedItem {
            let row = outlineView.rowForItem(item)
            if row != -1 {
                outlineView.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection: false)
            }
        }
        
        // thanks to the update we may have unrechable nodes so GC them
        // Changing GC frequency is an obvious optimization avenue
        hierarchy.collectGarbage()
    }
}
