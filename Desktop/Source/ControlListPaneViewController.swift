//
//  ControlListPaneViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 3/15/15.
//
//

import Cocoa

protocol ControlListPaneViewControllerDelegate : class {
    func paneController(controller : ControlListPaneViewController, changedControlInfo info: DLSControlInfo, toValue value : NSCoding?)
    func paneController(controller : ControlListPaneViewController, shouldSaveControlInfo info: DLSControlInfo, withValue value : NSCoding?)
}

class ControlListPaneViewController: NSViewController, ControlControllerDelegate {
    
    @IBOutlet private var stackView : NSStackView?
    private var controlControllers : [ControlController] = []
    weak var delegate : ControlListPaneViewControllerDelegate?
    let group : String
    
    init?(group : String, delegate : ControlListPaneViewControllerDelegate) {
        self.group = group
        self.delegate = delegate
        super.init(nibName: "ControlListPaneViewController", bundle: nil)
        self.title = group
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for controller in controlControllers {
            self.stackView?.addView(controller.view, inGravity: .Top)
        }
    }
    
    var isEmpty : Bool {
        return controlControllers.count == 0
    }
    
    func addControlWithInfo(controlInfo : DLSControlInfo) {
        let editorController = (controlInfo.editor as! EditorControllerGenerating).generateController()
        editorController.view.translatesAutoresizingMaskIntoConstraints = false
        let controller = ControlController(controlInfo : controlInfo, contentController : editorController, delegate : self)
        controlControllers.append(controller)
        controlControllers.sortInPlace { (left, right) -> Bool in
            left < right
        }
        let i = controlControllers.indexOf(controller)!
        if(self.viewLoaded) {
            NSAnimationContext.runAnimationGroup({ctx in
                ctx.allowsImplicitAnimation = true
                self.stackView?.insertView(controller.view, atIndex: i, inGravity: .Top)
            }, completionHandler: nil)
        }
    }
    
    func removeControlWithID(controlID : String) {
        let index = controlControllers.indexOf {
            $0.controlInfo.uuid == controlID
        }
        guard let i = index else {
            return
        }
        
        guard let view = self.stackView?.views[i] else {
            return
        }
        
        self.controlControllers.removeAtIndex(i)
        
        NSAnimationContext.runAnimationGroup({ctx in
            ctx.allowsImplicitAnimation = true
            self.stackView?.removeView(view)
            }, completionHandler: nil)
    }

    func controlController(controller: ControlController, changedControlInfo info: DLSControlInfo, toValue value: NSCoding?) {
        delegate?.paneController(self, changedControlInfo: info, toValue: value)
    }
    
    func controlController(controller: ControlController, shouldSaveControlInfo info: DLSControlInfo, withValue value: NSCoding?) {
        delegate?.paneController(self, shouldSaveControlInfo: info, withValue: value)
    }
    

}
