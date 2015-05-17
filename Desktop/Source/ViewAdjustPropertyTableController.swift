//
//  ViewAdjustPropertyTableController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 4/19/15.
//
//

import Cocoa

protocol ViewAdjustPropertyTableControllerDelegate : class {
    func tableController(controller : ViewAdjustPropertyTableController, valueChangedWithRecord record : DLSChangeViewValueRecord)
}

class ViewAdjustPropertyTableController: NSObject, PropertyGroupViewDelegate {
    weak var delegate : ViewAdjustPropertyTableControllerDelegate?
    
    var record : DLSViewRecord?
    var selectedViewID : NSString?
    
    @IBOutlet var stackView : NSStackView?
    @IBOutlet var emptyView : NSView?
    
    var groupViews : [String:PropertyGroupView] = [:]
    
    override func awakeFromNib() {
        addEmptyView()
    }
    
    func useRecord(record : DLSViewRecord) {
        let lastViewID = self.record?.viewID
        self.record = record
        if let viewID = self.record?.viewID where viewID == lastViewID {
            updateValues()
        }
        else {
            rebuildTable()
        }
    }
    
    func groups() -> [DLSPropertyGroup] {
        return self.record?.propertyGroups as? [DLSPropertyGroup] ?? []
    }
    
    func clear() {
        record = nil
        selectedViewID = nil
        rebuildTable()
    }
    
    func updateValues() {
        for group in groups() {
            let view = groupViews[group.displayName]
            let values : [String:NSCoding] = record?.values[group.displayName] as? [String:NSCoding] ?? [:]
            for description in group.properties as! [DLSPropertyDescription] {
                view?.takeValue(values[description.name], name: description.name)
            }
        }
    }
    
    func rebuildTable() {
        groupViews = [:]
        for view in stackView?.views ?? [] {
            stackView?.removeView(view as! NSView)
        }
        for group in groups() {
            let groupView  = PropertyGroupView(frame : CGRectZero)
            groupView.translatesAutoresizingMaskIntoConstraints = false
            groupView.delegate = self
            groupView.viewID = record?.viewID
            stackView?.addView(groupView, inGravity: .Top)
            let values : [String:NSCoding] = record?.values[group.displayName] as? [String:NSCoding] ?? [:]
            groupView.useGroup(group, values: values)
            groupViews[group.displayName] = groupView
        }
        
        if count(stackView?.views ?? []) == 0 {
            addEmptyView()
        }
        else {
            emptyView?.hidden = true
        }
    }
    
    func addEmptyView() {
        // add a dummy view to the stack so autolayout doesn't get confused
        let view = NSView(frame : NSZeroRect)
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView?.addView(view, inGravity: .Top)
        emptyView?.hidden = false
    }
    
    func propertyGroupView(view: PropertyGroupView, changedItem name: String, toValue value: NSCoding?) {
        
        if view.viewID == record?.viewID {
            // make sure this comes from the current view
            // to deal with the case where ending first responder on the old view
            // causes it to send value changed messages
            
            let changeRecord = DLSChangeViewValueRecord(viewID: record!.viewID!, name: name, group: view.groupName!, value: value)
            self.delegate?.tableController(self, valueChangedWithRecord : changeRecord)
        }
    }
    
}
