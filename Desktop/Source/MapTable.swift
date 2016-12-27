//
//  MapTable.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/18/15.
//
//

import Foundation

enum MapTableKind {
    case weakToWeak
    case weakToStrong
    case strongToWeak
    case strongToStrong
}

private class MapTableBacking<A : AnyObject, B : AnyObject> {
    let backing : NSMapTable<AnyObject, AnyObject>
    
    init(kind : MapTableKind) {
        switch(kind) {
        case .weakToWeak:
            backing = NSMapTable.weakToWeakObjects()
        case .weakToStrong:
            backing = NSMapTable.weakToStrongObjects()
        case .strongToWeak:
            backing = NSMapTable.strongToWeakObjects()
        case .strongToStrong:
            backing = NSMapTable.strongToStrongObjects()
        }
    }
    
    fileprivate init(backing : NSMapTable<AnyObject, AnyObject>) {
        self.backing = backing
    }
    
    func copy() -> MapTableBacking<A, B> {
        return MapTableBacking(backing : backing.copy() as! NSMapTable)
    }
    
    subscript(key : A) -> B? {
        get {
            return backing.object(forKey: key) as? B
        }
        set {
            if let v = newValue {
                backing.setObject(v, forKey: key)
            }
            else {
                backing.removeObject(forKey: key)
            }
        }
    }
}

struct MapTable<A : AnyObject, B : AnyObject> {
    
    fileprivate var backing : MapTableBacking<A, B>
    
    init(kind : MapTableKind) {
        backing = MapTableBacking(kind : kind)
    }
    
    subscript(key : A) -> B? {
        get {
            return backing[key]
        }
        set {
            if !isKnownUniquelyReferenced(&self.backing) {
                backing = backing.copy()
            }
            backing[key] = newValue
        }
    }
}
