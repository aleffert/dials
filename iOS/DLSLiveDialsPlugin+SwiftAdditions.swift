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
    
    /// Adds a new dial.
    ///
    /// :param: wrapper     Moves data in and out of the underlying store.
    /// :param: value       The initial value.
    /// :param: editor      The desktop side editor for the property.
    /// :param: displayName The user facing name of the dial.
    /// :param: canSave     Whether it is possible to save changes to this property directly back to your code.
    /// :param: file        The name of the file this dial is declared in.
    /// :param: line        The line of code this dial is declared on.
    func addDial<A : AnyObject>(
        wrapper : PropertyWrapper<A>,
        value : A,
        editor : DLSEditorDescription,
        displayName : String,
        canSave : Bool,
        file : String,
        line : UInt
        ) -> DLSRemovable
    {
        
        let wrapperWrapper = DLSPropertyWrapper(
            getter: {
                wrapper.get()
            },
            setter : {
                wrapper.set($0 as! A)
            }
        )
        
        return addDialWithWrapper(
            wrapperWrapper,
            value: value,
            editor: editor,
            displayName: displayName,
            canSave: canSave,
            file: file,
            line: Int(line)
        )
    }
}

/// Adds a new dial.
///
/// :param: displayName The text of the button's label.
/// :param: wrapper     Moves data in and out of the underlying store.
/// :param: value       The initial value.
/// :param: editor      The desktop side editor for the property
/// :param: canSave     Whether it is possible to save changes to this property directly back to your code.
/// :param: owner       If non-nil, the dial will be automatically removed when `owner` is deallocated.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddControl<A>(
    displayName : String,
    wrapper : PropertyWrapper<A>,
    value : A,
    editor : DLSEditorDescription,
    canSave: Bool = false,
    _ owner : AnyObject? = nil,
    _ line : UInt = __LINE__,
    _ file : String = __FILE__
    ) -> DLSRemovable {
    
    let remove = DLSLiveDialsPlugin.activePlugin()?.addDial(
        wrapper,
        value: value,
        editor: editor,
        displayName: displayName,
        canSave: canSave,
        file : file,
        line : line
        )
        
    if let o : AnyObject = owner {
        o.dls_performActionOnDealloc({ Void -> Void in
            remove?.remove()
        })
    }
    return remove ?? NullRemovable()
}

// MARK: Type specific variants

// It seems like there should be a way to simplify this with currying, but as best I can tell
// that interacts poorly with default arguments.


/// Adds a new button to the control panel.
///
/// :param: displayName The text of the button's label.
/// :param: action      Moves data in and out of the underlying store.
/// :param: owner       If non-nil, the dial will be automatically removed when `owner` is deallocated.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddAction(
    displayName : String,
    owner : AnyObject? = nil,
    line : UInt = __LINE__,
    file : String = __FILE__,
    action : Void -> Void
    )
{
    // Use NSObject for the data since we need an object so we can't just send Void
    let getter : () -> NSObject = {
        action()
        return NSObject()
    }
    let setter = {(_ : NSObject) in
        return
    }
    let wrapper = PropertyWrapper(get: getter, set : setter)
    
    DLSAddControl(displayName, wrapper, NSObject(), DLSActionDescription(), canSave : true, owner, line, file)
}

/// Adds a new color well to the control panel.
///
/// :param: displayName The text of the button's label.
/// :param: source      The variable to make a control for.
/// :param: owner       If non-nil, the dial will be automatically removed when `owner` is deallocated.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddColorControl(
    displayName : String,
    inout source : UIColor,
    owner : AnyObject? = nil,
    line : UInt = __LINE__,
    file : String = __FILE__ ) -> DLSRemovable
{
    return DLSAddControl(displayName, PropertyWrapper(value : &source), source, DLSColorDescription(), canSave : false, owner, line, file)
}

/// Adds a new color well to the control panel.
///
/// :param: keyPath     The keypath of the owning object this corresponds to.
/// :param: owner       The owning object. The dial will be automatically removed when `owner` is deallocated.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddColorControl(
    #keyPath : String,
    owner : AnyObject,
    line : UInt = __LINE__,
    file : String = __FILE__) -> DLSRemovable
{
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return DLSAddControl(keyPath, wrapper, wrapper.get(), DLSColorDescription(), canSave : false, owner, line, file)
}

/// Adds a new slider to the control panel.
///
/// :param: displayName The text of the button's label.
/// :param: source      The variable to make a control for.
/// :param: owner       If non-nil, the dial will be automatically removed when `owner` is deallocated.
/// :param: min         The minimum value of the slider. Defaults to 0.
/// :param: max         The maximum value of the slider. Defaults to 1.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddSliderControl(displayName : String, inout source : Float, owner : AnyObject? = nil, min : Double = 0, max : Double = 1, line : UInt = __LINE__, file : String = __FILE__ ) -> DLSRemovable {
    let wrapper = PropertyWrapper(get: {
        NSNumber(float: source)
        }, set: {
            source = $0.floatValue
        }
    )
    return DLSAddControl(displayName, wrapper, wrapper.get(), DLSSliderDescription(min: min, max: max), canSave: true, owner, line, file)
}

/// Adds a new slider to the control panel.
///
/// :param: keyPath     The keypath of the owning object this corresponds to.
/// :param: min         The minimum value of the slider. Defaults to 0.
/// :param: max         The maximum value of the slider. Defaults to 1.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddSliderControl(#keyPath : String,
    min : Double = 0,
    max : Double = 0,
    owner : AnyObject,
    line : UInt = __LINE__,
    file : String = __FILE__) -> DLSRemovable
{
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return DLSAddControl(keyPath, wrapper, wrapper.get(), DLSSliderDescription(min: min, max: max), canSave : false, owner, line, file)
}


/// Adds a new check box toggle to the control panel
///
/// :param: displayName The text of the button's label.
/// :param: source      The variable to make a control for.
/// :param: owner       If non-nil, the dial will be automatically removed when `owner` is deallocated.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddToggleControl(
    displayName : String,
    inout source : Bool,
    owner : AnyObject? = nil,
    line : UInt = __LINE__,
    file : String = __FILE__
    ) -> DLSRemovable
{
    let wrapper = PropertyWrapper(get: {
        NSNumber(bool: source)
        }, set: {
            source = $0.boolValue
        }
    )
    return DLSAddControl(displayName, wrapper, wrapper.get(), DLSToggleDescription(), canSave : true, owner, line, file)
}

/// Adds a new check box toggle to the control panel
///
/// :param: keyPath     The keypath of the owning object this corresponds to.
/// :param: owner       If non-nil, the dial will be automatically removed when `owner` is deallocated.
/// :param: file        The name of the file this dial is declared in.
/// :param: line        The line of code this dial is declared on.
public func DLSAddToggleControl(
    #keyPath : String,
    owner : AnyObject,
    line : UInt = __LINE__,
    file : String = __FILE__
    ) -> DLSRemovable
{
    let wrapper = PropertyWrapper<NSObject>(owner, keyPath)
    return DLSAddControl(keyPath, wrapper, wrapper.get(), DLSToggleDescription(), canSave : false, owner, line, file)
}

