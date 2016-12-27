//
//  ConstraintsEditorController.swift
//  Dials+SnapKit
//
//  Created by Akiva Leffert on 9/24/15.
//  Copyright © 2015 Akiva Leffert. All rights reserved.
//

import Foundation
import Cocoa

class ConstraintsEditorController : NSObject, EditorController, ViewQuerierOwner, ConstraintViewDelegate {
    weak var delegate : EditorControllerDelegate?
    var viewQuerier : ViewQuerier?
    var lastConstraints : [DLSConstraintDescription] = []
    
    @IBOutlet fileprivate var editorView : NSView!
    @IBOutlet fileprivate var nothingLabel : NSView!
    @IBOutlet fileprivate var constraintStack : NSStackView!
    
    override init() {
        super.init()
        Bundle.main.loadNibNamed("ConstraintsEditorView", owner: self, topLevelObjects: nil)
    }
    
    var readOnly : Bool {
        return true
    }
    
    var view : NSView {
        return editorView!
    }
    
    fileprivate func firstPartOfConstraintDescription(_ description : DLSConstraintDescription) -> String {
        guard let source = viewQuerier?.nameForView(
            withID: description.sourceViewID,
            relativeToView: description.affectedViewID,
            withClass: description.sourceClass,
            constraintInfo: nil) else {
                return "Internal Error"
        }
        return "\(source).\(description.sourceAttribute)"
    }
    
    fileprivate func secondPartOfConstraintDescription(_ description : DLSConstraintDescription) -> String {
        let dest = viewQuerier?.nameForView(
            withID: description.destinationViewID,
            relativeToView: description.affectedViewID,
            withClass: description.destinationClass,
            constraintInfo: description.locationExtra
        )
        if let destName = dest, let destAttribute = description.destinationAttribute {
            var result = "\(destName).\(destAttribute)"
            if description.multiplier != 1 {
                result = result + " * \(stringFromNumber(description.multiplier))"
            }
            if description.constant != 0 {
                result = result + " + \(stringFromNumber(description.constant))"
            }
            return result
        }
        else {
            return "\(description.constant)"
        }
    }
    
    var configuration : EditorConfiguration? {
        didSet {
            if let constraints = configuration?.value as? [DLSConstraintDescription], constraints.count > 0 {
                
                constraintStack.isHidden = false
                nothingLabel.isHidden = true
                
                guard constraints != lastConstraints else {
                    return
                }
                
                lastConstraints = constraints
                constraintStack.setViews([], in: .top)
                
                for constraint in constraints {
                    let owner = ConstraintViewOwner()
                    Bundle.main.loadNibNamed("ConstraintView", owner: owner, topLevelObjects: nil)
                    if let view = owner.constraintView {
                        view.delegate = self
                        constraintStack.addView(view, in: .top)
                        view.constraint = constraint
                        view.fields = (
                            first: firstPartOfConstraintDescription(constraint),
                            relation: constraint.relation,
                            second: secondPartOfConstraintDescription(constraint)
                        )
                    }
                }
            }
            else {
                constraintStack.isHidden = true
                nothingLabel.isHidden = false
            }
        }
    }
    
    func constraintView(_ constraintView: ConstraintView, clearedHighlightViewWithID viewID: String) {
        self.viewQuerier?.clearHighlightForView(withID: viewID)
    }
    
    func constraintView(_ constraintView: ConstraintView, choseHighlightViewWithID viewID: String) {
        self.viewQuerier?.highlightView(withID: viewID)
    }
    
    func constraintView(_ constraintView: ConstraintView, selectedViewWithID viewID: String) {
        self.viewQuerier?.selectView(withID: viewID)
    }
    
    func constraintView(_ constraintView: ConstraintView, savedConstant constant: CGFloat, constraintID: String) {
        if let constraint = constraintView.constraint, let saveInfo = constraint.saveExtra {
            self.viewQuerier?.saveConstraint(withInfo: saveInfo, constant: constant)
        }
    }
    
    func constraintView(_ constraintView: ConstraintView, updatedConstant constant: CGFloat, constraintID: String) {
        self.delegate?.editorController(self, changedToValue: DLSUpdateConstraintConstantMessage(constraintID: constraintID, constant: constant))
        if let constraint = constraintView.constraint {
            constraintView.fields = (
                first: firstPartOfConstraintDescription(constraint),
                relation: constraint.relation,
                second: secondPartOfConstraintDescription(constraint)
            )
        }
    }

}

extension DLSConstraintsEditor : EditorControllerGenerating {
    public func generateController() -> EditorController {
        return ConstraintsEditorController()
    }
}
