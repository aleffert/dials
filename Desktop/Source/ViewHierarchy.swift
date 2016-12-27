//
//  ViewHierarchy.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/24/15.
//
//

enum ViewRelation {
    case same
    case superview
    case none
}

class ViewHierarchy {
    var map : [String:DLSViewHierarchyRecord] = [:]
    var roots : [String] = []
    
    subscript(key : String) -> DLSViewHierarchyRecord? {
        get {
            return map[key]
        }
        set {
            map[key] = newValue
        }
    }
    
    
    fileprivate func collectActiveEntries(_ entries : inout [String:DLSViewHierarchyRecord], roots : [String]) {
        for root in roots {
            if let record = self[root] {
                entries[root] = record
                collectActiveEntries(&entries, roots: record.children as [String])
            }
        }
    }
    
    func collectGarbage() {
        var activeEntries : [String:DLSViewHierarchyRecord] = [:]
        collectActiveEntries(&activeEntries, roots:roots)
        map = activeEntries
    }
    
    func relationFrom(_ baseID : String, toView viewID: String) -> ViewRelation {
        if baseID == viewID {
            return .same
        }
        else if let record = map[viewID], record.children.contains(baseID) {
            return .superview
        }
        else {
            return .none
        }
    }
    
    static func niceNameForClassName(_ name : String?) -> String {
        guard let name = name else {
            return defaultViewName
        }
        guard let expression = try? NSRegularExpression(pattern: "([A-Z])", options: NSRegularExpression.Options()) else {
            return name
        }
        let withSplitter = expression.stringByReplacingMatches(in: name, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: name.characters.count), withTemplate: "$1@")
        let parts = withSplitter.components(separatedBy: "@")
        var finalParts : [String] = []
        var finishedPrefix = false
        var last : String? = nil
        for part in parts {
            if part.characters.count > 1 {
                finishedPrefix = true
                if let first = last {
                    finalParts.append(first.lowercased())
                }
            }
            if finishedPrefix {
                if finalParts.count > 1 {
                    finalParts.append(part.capitalized)
                }
                else {
                    finalParts.append(part.lowercased())
                }
            }
            last = part
        }
        
        return finalParts.joined(separator: "")
        
    }
    
    static let defaultViewName = "view"
}

