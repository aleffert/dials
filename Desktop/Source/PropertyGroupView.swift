//
//  PropertyGroupView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/19/15.
//
//

import Cocoa

protocol PropertyGroupViewDelegate: class {
    func propertyGroupView(view : PropertyGroupView, changedItem name : String, toValue value : NSCoding?)
}

class PropertyGroupViewOwner : NSObject {
    @IBOutlet var view : PropertyGroupView?
}

class PropertyGroupView: NSView, EditorViewDelegate {
    
    weak var delegate : PropertyGroupViewDelegate?
    
    @IBOutlet private var titleView : NSTextField?
    @IBOutlet private var propertyStack : NSStackView?
    
    private var propertyViews : [String:EditorView] = [:]
    
    var groupName : String?
    
    override func awakeFromNib() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func useGroup(group : DLSPropertyGroup, values:[String:NSCoding]) {
        groupName = group.displayName
        titleView?.stringValue = group.displayName
        for view in propertyStack?.views ?? [] {
            propertyStack?.removeView(view as! NSView)
        }
        for description in group.properties as! [DLSPropertyDescription] {
            let generator = description.editorDescription as? EditorViewGenerating
            let view = generator?.generate()
            view?.delegate = self
            view?.translatesAutoresizingMaskIntoConstraints = false
            let value = values[description.name]
            view?.info = EditorInfo(editor : description.editorDescription, name : description.displayName, value : value)
            if let v = view {
                let container = NSView(frame:NSZeroRect)
                container.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(v)
                v.addConstraintsMatchingSuperviewBounds()
                propertyStack?.addView(container, inGravity: .Top)
            }
        }
    }
    
    func takeValue(value : NSCoding?, name : String) {
        let view = propertyViews[name]
        if let v = view {
            v.info = EditorInfo(editor : v.info!.editor, name : v.info!.name, value : value)
        }
    }
    
    func editorView(view: EditorView, changedInfo info: EditorInfo, toValue value: NSCoding?) {
        self.delegate?.propertyGroupView(self, changedItem: info.name, toValue: value)
    }
    
}
