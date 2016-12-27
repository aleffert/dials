//
//  PropertyGroupView.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/19/15.
//
//

import Cocoa

protocol PropertyGroupViewDelegate: class, ViewQuerier {
    func propertyGroupView(_ view : PropertyGroupView, changedItem name : String, toValue value : NSCoding?)
}

class PropertyGroupView: NSView, EditorControllerDelegate, ViewQuerier {
    
    weak var delegate : PropertyGroupViewDelegate?
    
    var viewID : String?
    @IBOutlet fileprivate var groupView : GroupContainerView!
    @IBOutlet fileprivate var propertyStack : NSStackView!
    
    fileprivate var propertyControllers : [String:EditorController] = [:]
    
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
        Bundle.main.loadNibNamed("PropertyGroupView", owner: self, topLevelObjects: nil)
        groupView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(groupView)
        groupView.addConstraintsMatchingSuperviewBounds()
        groupView.contentView = propertyStack
    }
    
    func useGroup(_ group : DLSPropertyGroup, values:[String:NSCoding]) {
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
                propertyStack?.addView(container, in: .top)
                propertyControllers[description.name] = controller
            }
        }
    }
    
    func takeValue(_ value : NSCoding?, name : String) {
        if let controller = propertyControllers[name] {
            controller.configuration = EditorInfo(editor : controller.configuration!.editor, name : controller.configuration!.name, label : controller.configuration!.label, value : value)
        }
    }
    
    func editorController(_ controller: EditorController, changedToValue value: NSCoding?) {
        self.delegate?.propertyGroupView(self, changedItem: controller.configuration!.name, toValue: value)
    }
    
    func saveConstraint(withInfo info: DLSAuxiliaryConstraintInformation, constant: CGFloat) {
        self.delegate?.saveConstraint(withInfo: info, constant: constant)
    }
    
    func nameForView(withID mainID: String?, relativeToView relativeID: String, withClass className: String?, constraintInfo: DLSAuxiliaryConstraintInformation?) -> String {
        return self.delegate?.nameForView(withID: mainID, relativeToView: relativeID, withClass: className, constraintInfo : constraintInfo) ?? ViewHierarchy.defaultViewName
    }
    
    func highlightView(withID viewID: String) {
        self.delegate?.highlightView(withID: viewID)
    }
    
    func clearHighlightForView(withID viewID: String) {
        self.delegate?.clearHighlightForView(withID: viewID)
    }
    
    func selectView(withID viewID: String) {
        self.delegate?.selectView(withID: viewID)
    }
}
