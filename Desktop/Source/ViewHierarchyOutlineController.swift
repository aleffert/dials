//
//  ViewHierarchyOutlineController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/5/15.
//
//

import Cocoa

protocol ViewHierarchyOutlineControllerDelegate : class {
    func outlineController(_ controller : ViewsHierarchyOutlineController, selectedViewWithID viewID: String?)
}

class ViewsHierarchyOutlineController : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    @IBOutlet fileprivate var outlineView : NSOutlineView!
    weak var delegate : ViewHierarchyOutlineControllerDelegate?
    
    // NSOutlineView requires direct object identity so we need a way to convert
    // ids to a canonical representation
    // TODO: GC these
    var canonicalKeys : [String: Any] = [:]
    
    let hierarchy = ViewHierarchy()
    
    fileprivate func canonicalize(_ value : String) -> Any {
        if let canon = canonicalKeys[value] {
            return canon
        }
        else {
            canonicalKeys[value] = value
            return value
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return hierarchy.roots.count
        }
        else {
            let record = hierarchy[item as! String]
            return record?.children.count ?? 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return canonicalize(hierarchy.roots[index])
        }
        else {
            let record = hierarchy[item as! NSString as String]
            guard let child = record?.children[index] else {
                assertionFailure("Unexpected index")
                return ""
            }
            return canonicalize(child)
        }
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        let record = hierarchy[item as! NSString as String]
        return record.map {$0.children.count > 0} ?? false
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let cell = outlineView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
        
        if let record = hierarchy[item as! NSString as String] {
            cell.textField!.stringValue = "\(record.label) - \(record.address)"
        }
        return cell
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let outlineView = notification.object as! NSOutlineView
        let selectionIndexes = outlineView.selectedRowIndexes
        if selectionIndexes.count == 0 {
            delegate?.outlineController(self, selectedViewWithID: nil)
        }
        else {
            let item = outlineView.item(atRow: selectionIndexes.first!) as! String
            delegate?.outlineController(self, selectedViewWithID: item)
        }
    }
    
    func useHierarchy(_ hierarchy : [String : DLSViewHierarchyRecord], roots : [String]) {
        self.hierarchy.map = hierarchy
        self.hierarchy.roots = roots
        outlineView.reloadData()
    }
    
    var hasSelection : Bool {
        return outlineView?.selectedRow != -1
    }
    
    fileprivate var selectedViewID : String? {
        let selectedRow = outlineView!.selectedRow
        var selectedItem : String? = nil
        if selectedRow != -1 {
            selectedItem = outlineView.item(atRow: selectedRow) as? String
        }
        return selectedItem
    }
    
    func selectViewWithID(_ viewID : String?) {
        if let viewID = viewID {
            var parents : [String] = []
            var current = hierarchy[viewID]?.superviewID
            while current != nil {
                parents.insert(current! as NSString as String, at: 0)
                current = hierarchy[current! as NSString as String]?.superviewID
            }
            
            for item in parents {
                outlineView.expandItem(canonicalize(item))
            }
            
            let row = outlineView.row(forItem: canonicalize(viewID))
            if row != -1 {
                outlineView.selectRowIndexes(IndexSet(integer:row), byExtendingSelection: false)
            }
        }
        else {
            outlineView.deselectAll(nil)
        }
    }
    
    func takeUpdateRecords(_ records : [DLSViewHierarchyRecord], roots : [String]) {
        self.hierarchy.roots = roots
        for record in records {
            hierarchy[record.viewID] = record
        }
        
        let selectedItem = selectedViewID
        
        outlineView.reloadData()
        
        if let item = selectedItem {
            let row = outlineView.row(forItem: item)
            if row != -1 {
                outlineView.selectRowIndexes(IndexSet(integer:row), byExtendingSelection: false)
            }
        }
        
        // thanks to the update we may have unreachable nodes so GC them
        // Changing GC frequency is an obvious optimization avenue
        hierarchy.collectGarbage()
    }
}
