//
//  SidebarSplitViewController.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/12/14.
//
//

import AppKit

private let SidebarMinWidth : CGFloat = 200.0
private let SidebarSplitViewName = "SidebarSplitViewName"

class EmptyViewController : NSViewController {
    override func loadView() {
        self.view = NSView(frame: CGRectMake(0, 0, 100, 100))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: SidebarMinWidth))
    }
}

class SidebarSplitViewController: NSSplitViewController {
    
    private let sidebarItem = NSSplitViewItem(viewController: EmptyViewController(nibName: nil, bundle: nil)!)
    private let contentItem = NSSplitViewItem(viewController: EmptyViewController(nibName: nil, bundle: nil)!)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupItems()
    }
    
    private func setupItems() {
        sidebarItem.canCollapse = true
        sidebarItem.collapsed = true
    }
    
    override func viewDidLoad() {
        sidebarItem.holdingPriority = 400
        addSplitViewItem(sidebarItem)
        addSplitViewItem(contentItem)
        hideSidebar()
    }
    
    override func loadView() {
        self.splitView = NSSplitView(frame: CGRectZero)
        self.splitView.vertical = true
        self.splitView.dividerStyle = .Thin
        self.splitView.autosaveName = SidebarSplitViewName
        self.splitView.identifier = SidebarSplitViewName
        self.view = self.splitView
    }
    
    func useSidebarContent(view : NSView) {
        for child in sidebarItem.viewController.view.subviews as! Array<NSView> {
            if child != view {
                view.removeFromSuperview()
            }
        }
        sidebarItem.viewController.view.addSubview(view)
        view.addConstraintsMatchingSuperviewBounds()
    }
    
    func useBodyContent(view : NSView) {
        for child in contentItem.viewController.view.subviews as! Array<NSView> {
            if child != view {
                child.removeFromSuperview()
            }
        }
        contentItem.viewController.view.addSubview(view)
        view.addConstraintsMatchingSuperviewBounds()
    }
    
    func showSidebar() {
        sidebarItem.animator().collapsed = false
    }
    
    func hideSidebar() {
        sidebarItem.animator().collapsed = true
    }
    
    var isSidebarVisible : Bool {
        return !sidebarItem.collapsed
    }
    
    func toggleSidebar() {
        sidebarItem.animator().collapsed = !sidebarItem.collapsed
    }

}
