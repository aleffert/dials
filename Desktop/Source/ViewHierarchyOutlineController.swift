//
//  ViewHierarchyOutlineController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/5/15.
//
//

import Cocoa

protocol ViewHierarchyOutlineControllerDelegate : class {
    func outlineController(controller : ViewsHierarchyOutlineController, selectedViewWithID viewID: String?)
}

class ViewsHierarchyOutlineController : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    @IBOutlet private var outlineView : NSOutlineView!
    weak var delegate : ViewHierarchyOutlineControllerDelegate?
    
    // NSOutlineView requires direct object identity so we need a way to convert
    // ids to a canonical representation
    // TODO: GC these
    var canonicalKeys : [NSString: NSString] = [:]
    
    let hierarchy = ViewHierarchy()
    
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
        return record.map {$0.children.count > 0} ?? false
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let cell = outlineView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if let record = hierarchy[item as! NSString] {
            cell.textField!.stringValue = "\(record.label) - \(record.address)"
        }
        return cell
    }
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        let outlineView = notification.object as! NSOutlineView
        let selectionIndexes = outlineView.selectedRowIndexes
        if selectionIndexes.count == 0 {
            delegate?.outlineController(self, selectedViewWithID: nil)
        }
        else {
            let item = outlineView.itemAtRow(selectionIndexes.firstIndex) as! String
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
    
    private var selectedViewID : String? {
        let selectedRow = outlineView!.selectedRow
        var selectedItem : String? = nil
        if selectedRow != -1 {
            selectedItem = outlineView.itemAtRow(selectedRow) as? String
        }
        return selectedItem
    }
    
    func selectViewWithID(viewID : NSString?) {
        if let viewID = viewID {
            var parents : [NSString] = []
            var current = hierarchy[viewID]?.superviewID
            while current != nil {
                parents.insert(current!, atIndex: 0)
                current = hierarchy[current!]?.superviewID
            }
            
            for item in parents {
                outlineView.expandItem(canonicalize(item))
            }
            
            let row = outlineView.rowForItem(canonicalize(viewID))
            if row != -1 {
                outlineView.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection: false)
            }
        }
        else {
            outlineView.deselectAll(nil)
        }
    }
    
    func takeUpdateRecords(records : [DLSViewHierarchyRecord], roots : [NSString]) {
        self.hierarchy.roots = roots
        for record in records {
            hierarchy[record.viewID] = record
        }
        
        let selectedItem = selectedViewID
        
        outlineView.reloadData()
        
        if let item = selectedItem {
            let row = outlineView.rowForItem(item)
            if row != -1 {
                outlineView.selectRowIndexes(NSIndexSet(index:row), byExtendingSelection: false)
            }
        }
        
        // thanks to the update we may have unreachable nodes so GC them
        // Changing GC frequency is an obvious optimization avenue
        hierarchy.collectGarbage()
    }
}
