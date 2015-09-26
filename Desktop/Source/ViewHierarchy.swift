//
//  ViewHierarchy.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/24/15.
//
//

enum ViewRelation {
    case Same
    case Superview
    case None
}

class ViewHierarchy {
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
                collectActiveEntries(&entries, roots: record.children)
            }
        }
    }
    
    func collectGarbage() {
        var activeEntries : [NSString:DLSViewHierarchyRecord] = [:]
        collectActiveEntries(&activeEntries, roots:roots)
        map = activeEntries
    }
    
    func relationFrom(baseID : String, toView viewID: String) -> ViewRelation {
        if baseID == viewID {
            return .Same
        }
        else if let record = map[viewID] where record.children.contains(baseID) {
            return .Superview
        }
        else {
            return .None
        }
    }
    
    static func niceNameForClassName(name : String?) -> String {
        guard let name = name else {
            return defaultViewName
        }
        guard let expression = try? NSRegularExpression(pattern: "([A-Z])", options: NSRegularExpressionOptions()) else {
            return name
        }
        let withSplitter = expression.stringByReplacingMatchesInString(name, options: NSMatchingOptions(), range: NSRange(location: 0, length: name.characters.count), withTemplate: "$1@")
        let parts = withSplitter.componentsSeparatedByString("@")
        var finalParts : [String] = []
        var finishedPrefix = false
        var last : String? = nil
        for part in parts {
            if part.characters.count > 1 {
                finishedPrefix = true
                if let first = last {
                    finalParts.append(first.lowercaseString)
                }
            }
            if finishedPrefix {
                if finalParts.count > 1 {
                    finalParts.append(part.capitalizedString)
                }
                else {
                    finalParts.append(part.lowercaseString)
                }
            }
            last = part
        }
        
        return finalParts.joinWithSeparator("")
        
    }
    
    static let defaultViewName = "view"
}

