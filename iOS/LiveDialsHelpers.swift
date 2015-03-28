//
//  LiveDialsPlugin.swift
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit

public class PropertyWrapper<A : AnyObject> {
    
    let get : () -> A
    let set : A -> ()
    
    init(get : () -> A, set : A -> ()) {
        self.get = get
        self.set = set
    }
    
    init(inout value : A) {
        get = {
            value
        }
        set = {
            value = $0
        }
    }
    
    init(_ owner : AnyObject, _ keyPath : String) {
        get = {
            return owner.valueForKeyPath(keyPath) as A
        }
        set = {
            owner.setValue($0, forKeyPath:keyPath)
        }
    }
}

public extension DLSLiveDialsPlugin {
    func addDial<A>(wrapper : PropertyWrapper<A>, value : A, editor : DLSEditorDescription, displayName : String, canSave : Bool, file : String, line : UInt) -> DLSRemovable {
        let wrapperWrapper = DLSPropertyWrapper()
        wrapperWrapper.getter = {
            wrapper.get()
        }
        wrapperWrapper.setter = {
            wrapper.set($0 as A)
        }
        return self.addDialWithWrapper(wrapperWrapper, value: value, editor: editor, displayName: displayName, canSave: canSave, file: file, line: line)
    }
}

public func AddControl<A>(displayName : String, wrapper : PropertyWrapper<A>, value : A, editor : DLSEditorDescription, _ owner : AnyObject? = nil, _ line : UInt = __LINE__, _ file : String = __FILE__) -> DLSRemovable {
    
    let remove = DLSLiveDialsPlugin.sharedPlugin().addDial(wrapper, value: value, editor: editor, displayName: displayName, canSave: false, file: file, line: line)
    if let o : AnyObject = owner {
        o.dls_performActionOnDealloc({ () -> Void in
            remove.remove()
        })
    }
    return remove
}

public func AddAction(displayName : String, action : () -> (), owner : AnyObject? = nil, _ line : UInt = __LINE__, _ file : String = __FILE__) {
    let getter : () -> NSString = {
        action()
        return ""
    }
    let setter : NSString -> () = {_ in
        return
    }
    let wrapper = PropertyWrapper(get: getter, set : setter)
    AddControl(displayName, wrapper, getter(), DLSActionDescription(), owner, line, file)
}

public func AddColorControl(displayName : String, inout x : UIColor, owner : AnyObject? = nil, _ line : UInt = __LINE__, _ file : String = __FILE__ ) -> DLSRemovable {
    return AddControl(displayName, PropertyWrapper(value : &x), x, DLSColorDescription(),  owner, line, file)
}

public func AddColorControl(#keyPath : String, owner : AnyObject, _ line : UInt = __LINE__, _ file : String = __FILE__) -> DLSRemovable {
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return AddControl(keyPath, wrapper, wrapper.get(), DLSColorDescription(), owner, line, file)
}

public func AddSliderControl(displayName : String, inout x : Float, owner : AnyObject? = nil, min : Double = 0, max : Double = 1, _ line : UInt = __LINE__, _ file : String = __FILE__ ) -> DLSRemovable {
    let wrapper = PropertyWrapper(get: {
        NSNumber(float: x)
        }, set: {
            x = $0.floatValue
        }
    )
    return AddControl(displayName, wrapper, wrapper.get(), DLSSliderDescription(min: min, max: max), owner, line, file)
}

public func AddSliderControl(#keyPath : String, owner : AnyObject, _ line : UInt = __LINE__, _ file : String = __FILE__) -> DLSRemovable {
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return AddControl(keyPath, wrapper, wrapper.get(), DLSColorDescription(), owner, line, file)
}
