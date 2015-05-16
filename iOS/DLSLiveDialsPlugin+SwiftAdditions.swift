//
//  DLSLiveDialsPlugin+SwiftAdditions.swift
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit

/// Simple class that does nothing, but allows returning a non-optional value
/// for a cleaner interface
class NullRemovable : NSObject, DLSRemovable {
    func remove() {
        // do nothing
    }
}

/// Type carrying version of DLSPropertyWrapper
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
        get = {[weak owner] in
            return owner?.valueForKeyPath(keyPath) as! A
        }
        set = {[weak owner] (v : A) in
            owner?.setValue(v, forKeyPath:keyPath)
            return
        }
    }
}

/// Helpers for DLSLiveDialsPlugin to make it easier to use from Swift
public extension DLSLiveDialsPlugin {
    func addDial<A : AnyObject>(wrapper : PropertyWrapper<A>, value : A, editor : DLSEditorDescription, displayName : String, canSave : Bool, file : String, line : UInt) -> DLSRemovable {
        let wrapperWrapper = DLSPropertyWrapper(getter: {
            wrapper.get()
        }, setter : {
            wrapper.set($0 as! A)
        })
        
        return addDialWithWrapper(wrapperWrapper, value: value, editor: editor, displayName: displayName, canSave: canSave, file: file, line: Int(line))
    }
}

public func DLSAddControl<A>(displayName : String, wrapper : PropertyWrapper<A>, value : A, editor : DLSEditorDescription, canSave: Bool = false, _ owner : AnyObject? = nil, _ line : UInt = __LINE__, _ file : String = __FILE__) -> DLSRemovable {
    
    let remove = DLSLiveDialsPlugin.activePlugin()?.addDial(wrapper, value: value, editor: editor, displayName: displayName, canSave: canSave, file : file, line : line)
    if let o : AnyObject = owner {
        o.dls_performActionOnDealloc({ () -> Void in
            remove?.remove()
        })
    }
    return remove ?? NullRemovable()
}

public func DLSAddAction(displayName : String, action : (() -> ()), owner : AnyObject? = nil, _ line : UInt = __LINE__, _ file : String = __FILE__) {
    let getter : () -> NSString = {
        action()
        return ""
    }
    let setter : NSString -> () = {_ in
        return
    }
    let wrapper = PropertyWrapper(get: getter, set : setter)
    DLSAddControl(displayName, wrapper, "", DLSActionDescription(), canSave : true, owner, line, file)
}

public func DLSAddColorControl(displayName : String, inout x : UIColor, owner : AnyObject? = nil, _ line : UInt = __LINE__, _ file : String = __FILE__ ) -> DLSRemovable {
    return DLSAddControl(displayName, PropertyWrapper(value : &x), x, DLSColorDescription(), canSave : false, owner, line, file)
}

public func DLSAddColorControl(#keyPath : String, owner : AnyObject, _ line : UInt = __LINE__, _ file : String = __FILE__) -> DLSRemovable {
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return DLSAddControl(keyPath, wrapper, wrapper.get(), DLSColorDescription(), canSave : false, owner, line, file)
}

public func DLSAddSliderControl(displayName : String, inout x : Float, owner : AnyObject? = nil, min : Double = 0, max : Double = 1, _ line : UInt = __LINE__, _ file : String = __FILE__ ) -> DLSRemovable {
    let wrapper = PropertyWrapper(get: {
        NSNumber(float: x)
        }, set: {
            x = $0.floatValue
        }
    )
    return DLSAddControl(displayName, wrapper, wrapper.get(), DLSSliderDescription(min: min, max: max), canSave: true, owner, line, file)
}

public func DLSAddSliderControl(#keyPath : String, min : Double = 0, max : Double = 0, owner : AnyObject, _ line : UInt = __LINE__, _ file : String = __FILE__) -> DLSRemovable {
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return DLSAddControl(keyPath, wrapper, wrapper.get(), DLSSliderDescription(min: min, max: max), canSave : false, owner, line, file)
}

public func DLSAddToggleControl(displayName : String, inout x : Float, owner : AnyObject? = nil, min : Double = 0, max : Double = 1, _ line : UInt = __LINE__, _ file : String = __FILE__ ) -> DLSRemovable {
    let wrapper = PropertyWrapper(get: {
        NSNumber(float: x)
        }, set: {
            x = $0.floatValue
        }
    )
    return DLSAddControl(displayName, wrapper, wrapper.get(), DLSSliderDescription(min: min, max: max), canSave : true, owner, line, file)
}

public func DLSAddToggleControl(#keyPath : String, owner : AnyObject, _ line : UInt = __LINE__, _ file : String = __FILE__) -> DLSRemovable {
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return DLSAddControl(keyPath, wrapper, wrapper.get(), DLSToggleDescription(), canSave : false, owner, line, file)
}

