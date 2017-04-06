//
//  DLSControlPanelPlugin+SwiftAdditions.swift
//  Dials-iOS
//
//  Created by Akiva Leffert on 3/28/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

import UIKit


public extension NSObject {
    
    /// Create a new control whose lifetime matches self
    @discardableResult func DLSControl(
        _ label : String,
        line : Int = #line,
        file : String = #file) -> DLSReferenceControlBuilder {
            return DLSReferenceControlBuilder(label: label, canSave: true, owner : self, file : file, line : line)
    }
    
    /// Create a new control whose lifetime matches self
    @discardableResult func DLSControl(
        keyPath : String,
        line : Int = #line,
        file : String = #file) -> DLSKeyPathControlBuilder {
            return DLSKeyPathControlBuilder(keyPath: keyPath, canSave: false, owner : self, file : file, line : line)
    }
}

/// Type carrying version of DLSPropertyWrapper
class PropertyWrapper<A : AnyObject> {
    
    let get : () -> A
    let set : (A) -> ()
    
    init(get : @escaping () -> A, set : @escaping (A) -> ()) {
        self.get = get
        self.set = set
    }
    
    init(_ owner : AnyObject, _ keyPath : String) {
        get = {[weak owner] in
            return owner?.value(forKeyPath: keyPath) as! A
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
        _ wrapper : DLSPropertyWrapper<A>,
        editor : DLSEditor,
        label : String,
        owner : NSObject,
        canSave : Bool,
        file : String = #file,
        line : UInt = #line
        ) -> DLSRemovable
    {
        return addControl(
            with: wrapper as! DLSPropertyWrapper<AnyObject>,
            editor: editor,
            owner: owner,
            label: label,
            canSave: canSave,
            file: file,
            line: Int(line)
        )
    }
    
}

public func DLSGroupWithName(_ name: String, actions: () -> Void) {
    DLSControlPanelPlugin.active()?.beginGroup(withName: name)
    actions()
    DLSControlPanelPlugin.active()?.endGroup()
}

public extension DLSReferenceControlBuilder {
    
    @discardableResult func editorOf<T>(_ source : inout T, editor : DLSEditor, getT : @escaping (T) -> AnyObject, setT : @escaping (AnyObject) -> T) -> DLSRemovable {
        return withUnsafeMutablePointer(to: &source) {(source : UnsafeMutablePointer<T>) in
            let wrapper = DLSPropertyWrapper(
                getter: {_ in
                    return getT(source.pointee)
                }, setter : {newValue in
                    let value = setT(newValue!)
                    source.pointee = value
                    return
                }
            )
            return wrapperOf(wrapper, editor)
        }
    }
    
    @discardableResult func editorOf<T : AnyObject>(_ source : inout T, editor : DLSEditor) -> DLSRemovable {
        return editorOf(&source, editor: editor, getT: { $0 as AnyObject }, setT: { $0 as! T })
    }
    
    @discardableResult func editorOf(_ source : inout CGFloat, editor : DLSEditor) -> DLSRemovable {
        let getT : (CGFloat) -> AnyObject = {
            $0 as NSNumber
        }
        let setT : (AnyObject) -> CGFloat = {
            CGFloat(($0 as! NSNumber).floatValue)
        }
        return editorOf(&source, editor: editor, getT: getT, setT: setT)
    }
    
    @discardableResult func colorOf(_ source : inout UIColor) -> DLSRemovable {
        return editorOf(&source, editor: DLSColorEditor())
    }
    
    @discardableResult func edgeInsetsOf(_ source : inout UIEdgeInsets) -> DLSRemovable {
        return editorOf(&source, editor: DLSEdgeInsetsEditor(),
            getT: {
                DLSWrapUIEdgeInsets($0) as NSDictionary
            }, setT: {
                DLSUnwrapUIEdgeInsets($0 as! [AnyHashable: Any])
            }
        )
    }
    
    @discardableResult func labelOf(_ source : inout NSString) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldEditor.label())
    }
    
    @discardableResult func labelOf(_ source : inout String) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldEditor.label(), getT: {$0 as NSString}, setT: {$0 as! String})
    }
    
    @discardableResult func labelOf(_ source : UnsafeMutablePointer<String?>) -> DLSRemovable {
        let wrapper = DLSPropertyWrapper(getter: { () -> AnyObject? in
            return source.pointee as NSString?
            }) {
                source.pointee = $0 as? String
        }
        return wrapperOf(wrapper, DLSTextFieldEditor.label())
    }
    
    @discardableResult func imageOf(_ source : inout UIImage) -> DLSRemovable {
        return editorOf(&source, editor: DLSImageEditor())
    }
    
    @discardableResult func popupOf<T : DLSPopupEditing>(_ source : inout T) -> DLSRemovable {
        let items = T.dls_popupItems
        let optionItems = items.map { (name, value) in
            return DLSPopupOption(label: name, value: T.dls_wrapValue(value))
        }
        return editorOf(&source, editor: DLSPopupEditor(popupOptions : optionItems),
            getT: T.dls_wrapValue, setT: T.dls_unwrapValue)
    }
    
    @discardableResult func pointOf(_ source : inout CGPoint) -> DLSRemovable {
        return editorOf(&source, editor: DLSPointEditor(),
            getT: {
                DLSWrapCGPointPoint($0) as NSDictionary
            }, setT: {
                DLSUnwrapCGPointPoint($0 as! [AnyHashable: Any])
            }
        )
    }
    
    @discardableResult func rectOf(_ source : inout CGRect) -> DLSRemovable {
        return editorOf(&source, editor: DLSRectEditor(),
            getT: {
                DLSWrapCGPointRect($0) as NSDictionary
            }, setT: {
                DLSUnwrapCGPointRect($0 as! [AnyHashable: Any])
            }
        )
    }
    
    @discardableResult func sizeOf(_ source : inout CGSize) -> DLSRemovable {
        return editorOf(&source, editor: DLSSizeEditor(),
            getT: {
                DLSWrapCGPointSize($0) as NSDictionary
            }, setT: {
                DLSUnwrapCGPointSize($0 as! [AnyHashable: Any])
            }
        )
    }
    
    @discardableResult func stepperOf(_ source : inout CGFloat) -> DLSRemovable {
        return editorOf(&source, editor: DLSStepperEditor())
    }
    
    @discardableResult func sliderOf(_ source : inout CGFloat, min : Double = 0, max : Double = 1) -> DLSRemovable {
        return editorOf(&source, editor: DLSSliderEditor(min: min, max: max))
    }
    
    @discardableResult func textFieldOf(_ source : inout NSString) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldEditor.textField())
    }
    
    @discardableResult func textFieldOf(_ source : inout String) -> DLSRemovable {
        return editorOf(&source, editor: DLSTextFieldEditor.textField(), getT: {$0 as NSString}, setT: {$0 as! String})
    }
    
    @discardableResult func textFieldOf(_ source : UnsafeMutablePointer<String?>) -> DLSRemovable {
        let wrapper = DLSPropertyWrapper(getter: { () -> AnyObject? in
            return source.pointee as NSString?
        }) {
            source.pointee = $0 as? String
        }
        return wrapperOf(wrapper, DLSTextFieldEditor.textField())
    }
    
    @discardableResult func togggleOf(_ source : inout Bool) -> DLSRemovable {
        return editorOf(&source, editor: DLSToggleEditor(),
            getT: {
                $0 as NSNumber
            }, setT: {
                ($0 as! NSNumber).boolValue
            }
        )
    }
}
