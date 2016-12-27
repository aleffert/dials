//
//  FloatArrayEditor.swift
//  Dials
//
//  Created by Akiva Leffert on 5/22/15.
//  Copyright (c) 2015 Akiva Leffert. All rights reserved.
//

extension DLSFloatArrayEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        let view = EditorView.freshViewFromNib("FloatArrayEditorView") as! FloatArrayEditorView
        view.editor = self
        return view
    }
}


extension DLSFloatArrayEditor : CodeGenerating {
    
    public func code(forValue value: NSCoding?, language: Language) -> String {
        let constructor = self.constructor ?? ""
        
        let values = value as? [String:NSNumber] ?? [:]
        let fields = (labels)
        let params = fields.map {key -> (key: String, value: String) in
            let value = stringFromNumber(values[key] ?? (0 as NSNumber))
            return (key, value)
        }
        return constructor.formatWithParameters(Dictionary(elements : params))
    }
    
}

private class FloatArrayItem {
    let label : String
    var value : Float
    
    init(label : String, value : Float) {
        self.label = label
        self.value = value
    }
}

protocol FloatArrayItemViewDelegate : class {
    func view(_ view : FloatArrayItemView, changedValue: Double)
}

class FloatArrayItemView : NSView {
    
    @IBOutlet var label : NSTextField?
    @IBOutlet var field : NSTextField?
    @IBOutlet var stepper : NSStepper?
    
    weak var delegate : FloatArrayItemViewDelegate?
    
    override func awakeFromNib() {
        stepper?.minValue = -Double(FLT_MAX)
        stepper?.maxValue = Double(FLT_MAX)
        stepper?.increment = 1
    }

    @IBAction func textChanged(_ sender : NSTextField) {
        stepper?.floatValue = field?.floatValue ?? 0
        delegate?.view(self, changedValue: sender.doubleValue)
    }

    @IBAction func stepperChanged(_ sender : NSStepper) {
        field?.floatValue = sender.floatValue
        delegate?.view(self, changedValue: sender.doubleValue)
    }

    func useValue(_ value : String) {
        stepper?.stringValue = value
        field?.stringValue = value
    }

}

class FloatArrayItemViewNibOwner {
    @IBOutlet fileprivate var view : FloatArrayItemView?
}

class FloatArrayEditorView : EditorView, FloatArrayItemViewDelegate {
    
    @IBOutlet fileprivate var container : NSView!
    @IBOutlet fileprivate var name : NSTextField?
    
    fileprivate var orderedFields : [FloatArrayItemView] = []
    fileprivate var indexedFields : [String:FloatArrayItemView] = [:]
    
    fileprivate func columnCountForItemCount(_ count : Int) -> Int {
        if orderedFields.count < 2 {
            return 1
        }
        else if orderedFields.count < 8 {
            return 2
        }
        else if orderedFields.count < 15 {
            return 3
        }
        else {
            return 4
        }
    }
    
    fileprivate func addConstraintsForEditors() {
        let columns = columnCountForItemCount(orderedFields.count)
        
        var first : NSView? = nil
        for ((view, prev), i) in orderedFields.withPrevious().indexed() {
            let column = i % columns
            
            let leadingAnchor : NSView
            let leadingAlignAttribute : NSLayoutAttribute
            let leadingOffset : CGFloat
            let topAnchor : NSView
            let topAlignAttribute : NSLayoutAttribute
            let topOffset : CGFloat
            
            if let prev = prev {
                if column == 0 {
                    leadingAnchor = container
                    leadingAlignAttribute = .leading
                    leadingOffset = 0
                    topAnchor = prev
                    topAlignAttribute = .bottom
                    topOffset = 4
                    
                }
                else {
                    leadingAnchor = prev
                    leadingAlignAttribute = .trailing
                    leadingOffset = 4
                    topAnchor = prev
                    topAlignAttribute = .top
                    topOffset = 0
                }
                
                let widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: first!, attribute: .width, multiplier: 1, constant: 0)
                container.addConstraint(widthConstraint)
            }
            else {
                leadingAnchor = container
                leadingAlignAttribute = .leading
                leadingOffset = 0
                topAnchor = container
                topAlignAttribute = .top
                topOffset = 0
            }
            
            let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: topAnchor, attribute: topAlignAttribute, multiplier: 1, constant: topOffset)
            container.addConstraint(topConstraint)
            
            let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: leadingAnchor, attribute: leadingAlignAttribute, multiplier: 1, constant: leadingOffset)
            container.addConstraint(leadingConstraint)
            
            if column + 1 == columns {
                let trailingConstraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1, constant: 0)
                container.addConstraint(trailingConstraint)
            }
            
            if i + 1 == orderedFields.count {
                let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0)
                container.addConstraint(bottomConstraint)
            }
            
            if first == nil {
                first = view
            }
            
        }
    }
    
    fileprivate var editor : DLSFloatArrayEditor? {
        didSet {
            for label in (editor?.labels ?? []){
                let owner = FloatArrayItemViewNibOwner()
                Bundle.main.loadNibNamed("FloatArrayItemView", owner: owner, topLevelObjects: nil)
                if let view = owner.view {
                    view.label?.stringValue = label
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.delegate = self
                    orderedFields.append(view)
                    indexedFields[label] = view
                    container.addSubview(view)
                }
            }
            
            addConstraintsForEditors()
        }
    }
    
    override var configuration : EditorConfiguration? {
        didSet {
            let values = (configuration?.value as? [String:NSNumber]) ?? [:]
            for (key, value) in values {
                let field = indexedFields[key]
                field?.useValue(stringFromNumber(value, requireIntegerPart: false))
            }
            
            name?.stringValue = configuration?.label ?? ""
        }
    }
    
    func view(_ view: FloatArrayItemView, changedValue value: Double) {
        var values = (configuration?.value as? [String:NSNumber]) ?? [:]
        values[view.label!.stringValue] = value as NSNumber
        delegate?.editorController(self, changedToValue: values as NSCoding?)
    }
}
