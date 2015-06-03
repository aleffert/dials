//
//  DLSControlPanelPlugin+SwiftAdditions.swift
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit


public extension NSObject {
    
    func DLSControl(
        label : String,
        line : Int = __LINE__,
        file : String = __FILE__) -> DLSReferenceControlBuilder {
            return DLSReferenceControlBuilder(label: label, canSave: true, owner : self, file : file, line : line)
    }
    
    func DLSControl(
        #keyPath : String,
        line : Int = __LINE__,
        file : String = __FILE__) -> DLSKeyPathControlBuilder {
            return DLSKeyPathControlBuilder(keyPath: keyPath, canSave: false, owner : self, file : file, line : line)
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

/// Helpers for DLSControlPanelPlugin to make it easier to use from Swift
public extension DLSControlPanelPlugin {
    
    /// Adds a new control.
    ///
    /// :param: wrapper     Moves data in and out of the underlying store.
    /// :param: value       The initial value.
    /// :param: editor      The desktop side editor for the property.
    /// :param: label       The user facing name of the control.
    /// :param: canSave     Whether it is possible to save changes from this control directly back to your code.
    /// :param: file        The name of the file this control is declared in.
    /// :param: line        The line of code this control is declared on.
    func addDial<A : AnyObject>(
        wrapper : PropertyWrapper<A>,
        editor : DLSEditor,
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
        
        return addControlWithWrapper(
            wrapperWrapper,
            editor: editor,
            label: label,
            canSave: canSave,
            file: file,
            line: Int(line)
        )
    }
    
}

public func DLSGroupWithName(name: String, @noescape actions: () -> Void) {
    DLSControlPanelPlugin.activePlugin()?.beginGroupWithName(name)
    actions()
    DLSControlPanelPlugin.activePlugin()?.endGroup()
}

public extension DLSReferenceControlBuilder {

    
    func editorOf<T : AnyObject>(inout source : T, editor : DLSEditor) -> DLSRemovable {
        return withUnsafeMutablePointer(&source) {(source : UnsafeMutablePointer<T>) in
            let wrapper = DLSPropertyWrapper(
                getter: {_ in
                    return source.memory
                }, setter : {newValue in
                    source.memory = (newValue as! T)
                    return
                }
            )
            return wrapperOf(wrapper, editor)
        }
    }
    
    func editorOf<T>(inout source : T, editor : DLSEditor, getT : T -> AnyObject, setT : AnyObject -> T) -> DLSRemovable {
        return withUnsafeMutablePointer(&source) {(var source : UnsafeMutablePointer<T>) in
            let wrapper = DLSPropertyWrapper(
                getter: {_ in
                    return getT(source.memory)
                }, setter : {newValue in
                    
                    source.put(setT(newValue!))
                    return
                }
            )
            return wrapperOf(wrapper, editor)
        }
    }
    
    func editorOf(inout source : CGFloat, editor : DLSEditor) -> DLSRemovable {
        let getT : CGFloat -> AnyObject = {
            $0 as NSNumber
        }
        let setT : AnyObject -> CGFloat = {
            $0 as! NSNumber as CGFloat
        }
        return editorOf(&source, editor: editor, getT: getT, setT: setT)
    }
    
    func colorOf(inout source : UIColor) -> DLSRemovable {
        return editorOf(&source, editor: DLSColorEditor())
    }
    
    func edgeInsetsOf(inout source : UIEdgeInsets) -> DLSRemovable {
        return editorOf(&source, editor: DLSEdgeInsetsEditor(),
            getT: {
                DLSWrapUIEdgeInsets($0) as NSDictionary
            }, setT: {
                DLSUnwrapUIEdgeInsets($0 as! [NSObject:AnyObject])
            }
        )
    }
    
    func labelOf(inout source : NSString) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldEditor.label())
    }
    
    func imageOf(inout source : UIImage) -> DLSRemovable {
        return editorOf(&source, editor: DLSImageEditor())
    }
    
    func popupOf<T : DLSPopupEditing>(inout source : T) -> DLSRemovable {
        let items = T.dls_popupItems
        let optionItems = items.map { (name, value) in
            return DLSPopupOption(label: name, value: T.dls_wrapValue(value))
        }
        return editorOf(&source, editor: DLSPopupEditor(popupOptions : optionItems),
            getT: T.dls_wrapValue, setT: T.dls_unwrapValue)
    }
    
    func pointOf(inout source : CGPoint) -> DLSRemovable {
        return editorOf(&source, editor: DLSPointEditor(),
            getT: {
                DLSWrapCGPointPoint($0) as NSDictionary
            }, setT: {
                DLSUnwrapCGPointPoint($0 as! [NSObject:AnyObject])
            }
        )
    }
    
    func rectOf(inout source : CGRect) -> DLSRemovable {
        return editorOf(&source, editor: DLSRectEditor(),
            getT: {
                DLSWrapCGPointRect($0) as NSDictionary
            }, setT: {
                DLSUnwrapCGPointRect($0 as! [NSObject:AnyObject])
            }
        )
    }
    
    func sizeOf(inout source : CGSize) -> DLSRemovable {
        return editorOf(&source, editor: DLSSizeEditor(),
            getT: {
                DLSWrapCGPointSize($0) as NSDictionary
            }, setT: {
                DLSUnwrapCGPointSize($0 as! [NSObject:AnyObject])
            }
        )
    }
    
    func stepperOf(inout source : CGFloat) -> DLSRemovable {
        return editorOf(&source, editor: DLSStepperEditor())
    }
    
    func sliderOf(inout source : CGFloat, min : Double = 0, max : Double = 1) -> DLSRemovable {
        return editorOf(&source, editor: DLSSliderEditor(min: min, max: max))
    }
    
    func textFieldOf(inout source : NSString) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldEditor.textField())
    }
    
    func togggleOf(inout source : Bool) -> DLSRemovable {
        return editorOf(&source, editor: DLSToggleEditor(),
            getT: {
                $0 as NSNumber
            }, setT: {
                $0 as! NSNumber as Bool
            }
        )
    }
}
