//
//  ViewHierarchyOutlineController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/5/15.
//
//

import Cocoa

class ViewHierarchyOutlineController : NSObject, NSOutlineViewDataSource, NSOutlineViewDelegate {
    var hierarchy : [NSString:DLSViewHierarchyRecord] = [:]
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return hierarchy.count
        }
        else {
            let record = hierarchy[item as! NSString]
            return record?.children.count ?? 0
        }
    }
    
    func useHierarchy(items : NSArray) {
        hierarchy = [:]
    }
}
