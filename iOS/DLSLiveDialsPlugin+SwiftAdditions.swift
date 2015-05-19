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

public extension NSObject {
    
    func DLSControl(
        label : String,
        line : Int = __LINE__,
        file : String = __FILE__) -> DLSReferencePredial {
            return DLSReferencePredial(label: label, canSave: true, owner : self, file : file, line : line)
    }
    
    func DLSControl(
        #keyPath : String,
        line : Int = __LINE__,
        file : String = __FILE__) -> DLSKeyPathPredial {
            return DLSKeyPathPredial(keyPath: keyPath, canSave: true, owner : self, file : file, line : line)
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
    /// :param: label       The user facing name of the dial.
    /// :param: canSave     Whether it is possible to save changes to this property directly back to your code.
    /// :param: file        The name of the file this dial is declared in.
    /// :param: line        The line of code this dial is declared on.
    func addDial<A : AnyObject>(
        wrapper : PropertyWrapper<A>,
        editor : DLSEditorDescription,
        label : String,
        canSave : Bool,
        file : String = __FILE__,
        line : UInt = __LINE__
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
            editor: editor,
            label: label,
            canSave: canSave,
            file: file,
            line: Int(line)
        )
    }
}

public extension DLSReferencePredial {
    
    func editorOf<T : AnyObject>(inout source : T, editor : DLSEditorDescription) -> DLSRemovable {
        let wrapper = DLSPropertyWrapper(
            getter: {_ in
                return source
            }, setter : {newValue in
                source = newValue as! T
                return
            }
        )
        return wrapperOf(wrapper, editor)
    }
    
    func colorOf(inout source : UIColor) -> DLSRemovable {
        return editorOf(&source, editor: DLSColorDescription())
    }
    
    func labelOf(inout source : NSString) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldDescription.label())
    }
    
    func stepperOf(inout source : CGFloat) -> DLSRemovable {
        let wrapper = DLSPropertyWrapper(
            getter: {_ in
                return source as NSNumber
            }, setter : {newValue in
                source = newValue as! CGFloat
                return
            }
        )
        return wrapperOf(wrapper, DLSStepperDescription())
    }
    
    func sliderOf(inout source : CGFloat, min : Double = 0, max : Double = 1) -> DLSRemovable {
        let wrapper = DLSPropertyWrapper(
            getter: {_ in
                return source as NSNumber
            }, setter : {newValue in
                source = newValue as! CGFloat
                return
            }
        )
        return wrapperOf(wrapper, DLSSliderDescription(min: min, max: max))
    }
    
    func textFieldOf(inout source : NSString) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldDescription.textField())
    }
    
    func togggleOf(inout source : Bool) -> DLSRemovable {
        let wrapper = DLSPropertyWrapper(
            getter: {_ in
                return source as NSNumber
            }, setter : {newValue in
                source = newValue as! Bool
                return
            }
        )
        return wrapperOf(wrapper, DLSToggleDescription())
    }
}
