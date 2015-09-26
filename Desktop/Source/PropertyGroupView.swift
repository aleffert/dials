//
//  PropertyGroupView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/19/15.
//
//

import Cocoa

protocol PropertyGroupViewDelegate: class, ViewQuerier {
    func propertyGroupView(view : PropertyGroupView, changedItem name : String, toValue value : NSCoding?)
}

class PropertyGroupView: NSView, EditorControllerDelegate, ViewQuerier {
    
    weak var delegate : PropertyGroupViewDelegate?
    
    var viewID : String?
    @IBOutlet private var groupView : GroupContainerView!
    @IBOutlet private var propertyStack : NSStackView!
    
    private var propertyControllers : [String:EditorController] = [:]
    
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
        groupName = group.label
        groupView.title = group.label
        for view in propertyStack?.views ?? [] {
            propertyStack?.removeView(view)
        }
        propertyControllers = [:]
        for description in group.properties {
            let generator = description.editor as? EditorControllerGenerating
            let controller = generator?.generateController()
            controller?.delegate = self
            if let querierOwner = controller as? ViewQuerierOwner {
                querierOwner.viewQuerier = self
            }
            
            controller?.view.translatesAutoresizingMaskIntoConstraints = false
            let value = values[description.name]
            controller?.configuration = EditorInfo(editor : description.editor, name : description.name, label : description.label, value : value)
            if let v = controller?.view {
                let container = NSView(frame:NSZeroRect)
                container.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(v)
                v.addConstraintsMatchingSuperviewBounds()
                propertyStack?.addView(container, inGravity: .Top)
                propertyControllers[description.name] = controller
            }
        }
    }
    
    func takeValue(value : NSCoding?, name : String) {
        if let controller = propertyControllers[name] {
            controller.configuration = EditorInfo(editor : controller.configuration!.editor, name : controller.configuration!.name, label : controller.configuration!.label, value : value)
        }
    }
    
    func editorController(controller: EditorController, changedConfiguration configuration: EditorConfiguration, toValue value: NSCoding?) {
        self.delegate?.propertyGroupView(self, changedItem: configuration.name, toValue: value)
    }
    
    func nameForViewWithID(mainID: String?, relativeToView relativeID: String, withClass className: String?, file: String?, line: UInt) -> String {
        return self.delegate?.nameForViewWithID(mainID, relativeToView: relativeID, withClass: className, file: file, line: line) ?? ViewHierarchy.defaultViewName
    }
    
}
