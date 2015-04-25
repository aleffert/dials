//
//  ViewAdjustHierarchy.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/24/15.
//
//

class ViewAdjustHierarchy {
    var map : [NSString:DLSViewHierarchyRecord] = [:]
    var roots : [NSString] = []
    
    subscript(key : NSString) -> DLSViewHierarchyRecord? {
        get {
            return map[key]
        }
        set {
            map[key] = newValue
        }
    }
    
    
    private func collectActiveEntries(inout entries : [NSString:DLSViewHierarchyRecord], roots : [NSString]) {
        for root in roots {
            if let record = self[root] {
                entries[root] = record
                collectActiveEntries(&entries, roots: record.children as! [NSString])
            }
        }
    }
    
    func collectGarbage() {
        var activeEntries : [NSString:DLSViewHierarchyRecord] = [:]
        collectActiveEntries(&activeEntries, roots:roots)
        map = activeEntries
    }
}

