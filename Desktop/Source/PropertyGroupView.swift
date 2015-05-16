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

class PropertyGroupView: NSView, EditorViewDelegate {
    
    weak var delegate : PropertyGroupViewDelegate?
    
    @IBOutlet private var groupView : GroupContainerView!
    @IBOutlet private var propertyStack : NSStackView!
    
    private var propertyViews : [String:EditorView] = [:]
    
    var groupName : String?
    
    override init(frame : CGRect) {
        super.init(frame : frame)
        setup()
    }
    
    required init!(coder : NSCoder) {
        super.init(coder : coder)
        setup()
    }
    
    func setup() {
        NSBundle.mainBundle().loadNibNamed("PropertyGroupView", owner: self, topLevelObjects: nil)
        groupView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(groupView)
        groupView.addConstraintsMatchingSuperviewBounds()
        groupView.contentView = propertyStack
    }
    
    func useGroup(group : DLSPropertyGroup, values:[String:NSCoding]) {
        groupName = group.displayName
        groupView.title = group.displayName
        for view in propertyStack?.views ?? [] {
            propertyStack?.removeView(view as! NSView)
        }
        propertyViews = [:]
        for description in group.properties as! [DLSPropertyDescription] {
            let generator = description.editorDescription as? EditorViewGenerating
            let view = generator?.generateView()
            view?.delegate = self
            view?.translatesAutoresizingMaskIntoConstraints = false
            let value = values[description.name]
            view?.info = EditorInfo(editor : description.editorDescription, name : description.name, displayName : description.displayName, value : value)
            if let v = view {
                let container = NSView(frame:NSZeroRect)
                container.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(v)
                v.addConstraintsMatchingSuperviewBounds()
                propertyStack?.addView(container, inGravity: .Top)
                propertyViews[description.name] = v
            }
        }
    }
    
    func takeValue(value : NSCoding?, name : String) {
        let view = propertyViews[name]
        if let v = view {
            v.info = EditorInfo(editor : v.info!.editor, name : v.info!.name, displayName : v.info!.displayName, value : value)
        }
    }
    
    func editorView(view: EditorView, changedInfo info: EditorInfo, toValue value: NSCoding?) {
        self.delegate?.propertyGroupView(self, changedItem: info.name, toValue: value)
    }
    
}
