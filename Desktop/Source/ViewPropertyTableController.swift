//
//  ViewPropertyTableController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/19/15.
//
//

import Cocoa

protocol ViewPropertyTableControllerDelegate : class {
    func tableController(_ controller : ViewPropertyTableController, valueChangedWithRecord record : DLSChangeViewValueRecord)
    func tableController(_ controller : ViewPropertyTableController, selectViewWithID viewID: String)
    func tableController(_ controller : ViewPropertyTableController, highlightViewWithID viewID: String)
    func tableController(_ controller : ViewPropertyTableController, clearHighlightForViewWithID viewID: String)
    func tableController(_ controller : ViewPropertyTableController, nameOfConstraintWithInfo info:DLSAuxiliaryConstraintInformation) -> String?
    func tableController(_ controller : ViewPropertyTableController, saveConstraintWithInfo info: DLSAuxiliaryConstraintInformation, constant : CGFloat)
}

class ViewPropertyTableController: NSObject, PropertyGroupViewDelegate, ViewQuerier {
    weak var delegate : ViewPropertyTableControllerDelegate?
    
    var record : DLSViewRecord?
    var selectedViewID : NSString?
    var hierarchy : ViewHierarchy?
    
    @IBOutlet var stackView : NSStackView?
    @IBOutlet var emptyView : NSView?
    
    var groupViews : [String:PropertyGroupView] = [:]
    
    override func awakeFromNib() {
        addEmptyView()
    }
    
    func useRecord(_ record : DLSViewRecord) {
        let lastViewID = self.record?.viewID
        self.record = record
        if let viewID = self.record?.viewID, viewID == lastViewID {
            updateValues()
        }
        else {
            rebuildTable()
        }
    }
    
    func groups() -> [DLSPropertyGroup] {
        return self.record?.propertyGroups ?? []
    }
    
    func clear() {
        record = nil
        selectedViewID = nil
        rebuildTable()
    }
    
    func updateValues() {
        for group in groups() {
            let view = groupViews[group.label]
            let values = record?.values[group.label] ?? [:]
            for description in group.properties {
                view?.takeValue(values[description.name], name: description.name)
            }
        }
    }
    
    func rebuildTable() {
        groupViews = [:]
        for view in stackView?.views ?? [] {
            stackView?.removeView(view )
        }
        for group in groups() {
            let groupView  = PropertyGroupView(frame : CGRect.zero)
            groupView.translatesAutoresizingMaskIntoConstraints = false
            groupView.delegate = self
            groupView.viewID = record?.viewID
            stackView?.addView(groupView, in: .top)
            let values = record?.values[group.label] ?? [:]
            groupView.useGroup(group, values: values)
            groupViews[group.label] = groupView
        }
        
        if (stackView?.views ?? []).count == 0 {
            addEmptyView()
        }
        else {
            emptyView?.isHidden = true
        }
    }
    
    func addEmptyView() {
        // add a dummy view to the stack so autolayout doesn't get confused
        let view = NSView(frame : NSZeroRect)
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView?.addView(view, in: .top)
        emptyView?.isHidden = false
    }
    
    func propertyGroupView(_ view: PropertyGroupView, changedItem name: String, toValue value: NSCoding?) {
        
        if view.viewID == record?.viewID {
            // make sure this comes from the current view
            // to deal with the case where ending first responder on the old view
            // causes it to send value changed messages
            
            let changeRecord = DLSChangeViewValueRecord(viewID: record!.viewID!, name: name, group: view.groupName!, value: value)
            self.delegate?.tableController(self, valueChangedWithRecord : changeRecord)
        }
    }
    
    func nameForView(withID mainID: String?, relativeToView relativeID: String, withClass className: String?, constraintInfo info: DLSAuxiliaryConstraintInformation?) -> String {
        if let mainID = mainID, let hierarchy = hierarchy {
            switch hierarchy.relationFrom(relativeID, toView:mainID) {
            case .same:
                return "self"
            case .superview:
                return "super"
            case .none:
                
                if let
                    info = info,
                    let name = self.delegate?.tableController(self, nameOfConstraintWithInfo:info)
                {
                    return name
                }
                else {
                    return ViewHierarchy.niceNameForClassName(ViewHierarchy.defaultViewName)
                }
            }
        }
        return ViewHierarchy.defaultViewName
    }
    
    
    func highlightView(withID viewID: String) {
        self.delegate?.tableController(self, highlightViewWithID: viewID)
    }
    
    func selectView(withID viewID: String) {
        self.delegate?.tableController(self, selectViewWithID: viewID)
    }
    
    func clearHighlightForView(withID viewID: String) {
        self.delegate?.tableController(self, clearHighlightForViewWithID:viewID)
    }
    
    func saveConstraint(withInfo info: DLSAuxiliaryConstraintInformation, constant: CGFloat) {
        self.delegate?.tableController(self, saveConstraintWithInfo: info, constant: constant)
    }
}




