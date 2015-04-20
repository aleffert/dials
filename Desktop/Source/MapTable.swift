//
//  MapTable.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/18/15.
//
//

import Foundation

enum MapTableKind {
    case WeakToWeak
    case WeakToStrong
    case StrongToWeak
    case StrongToStrong
}

private class MapTableBacking<A : AnyObject, B : AnyObject> {
    let backing : NSMapTable
    
    init(kind : MapTableKind) {
        switch(kind) {
        case .WeakToWeak:
            backing = NSMapTable.weakToWeakObjectsMapTable()
        case .WeakToStrong:
            backing = NSMapTable.weakToStrongObjectsMapTable()
        case .StrongToWeak:
            backing = NSMapTable.strongToWeakObjectsMapTable()
        case .StrongToStrong:
            backing = NSMapTable.strongToStrongObjectsMapTable()
        }
    }
    
    private init(backing : NSMapTable) {
        self.backing = backing
    }
    
    func copy() -> MapTableBacking<A, B> {
        return MapTableBacking(backing : backing.copy() as! NSMapTable)
    }
    
    subscript(key : A) -> B? {
        get {
            return backing.objectForKey(key) as? B
        }
        set {
            if let v = newValue {
                backing.setObject(v, forKey: key)
            }
            else {
                backing.removeObjectForKey(key)
            }
        }
    }
}

struct MapTable<A : AnyObject, B : AnyObject> {
    
    private var backing : MapTableBacking<A, B>
    
    init(kind : MapTableKind) {
        backing = MapTableBacking(kind : kind)
    }
    
    subscript(key : A) -> B? {
        get {
            return backing[key]
        }
        set {
            if !isUniquelyReferencedNonObjC(&self.backing) {
                backing = backing.copy()
            }
            backing[key] = newValue
        }
    }
}
