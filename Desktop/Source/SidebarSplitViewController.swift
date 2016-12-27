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
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.view.addConstraint(NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: SidebarMinWidth))
    }
}

class SidebarSplitViewController: NSSplitViewController {
    
    fileprivate let sidebarItem = NSSplitViewItem(viewController: EmptyViewController(nibName: nil, bundle: nil)!)
    fileprivate let contentItem = NSSplitViewItem(viewController: EmptyViewController(nibName: nil, bundle: nil)!)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupItems()
    }
    
    fileprivate func setupItems() {
        sidebarItem.canCollapse = true
        sidebarItem.isCollapsed = true
    }
    
    override func viewDidLoad() {
        sidebarItem.holdingPriority = 400
        addSplitViewItem(sidebarItem)
        addSplitViewItem(contentItem)
        hideSidebar()
    }
    
    override func loadView() {
        self.splitView = NSSplitView(frame: CGRect.zero)
        self.splitView.isVertical = true
        self.splitView.dividerStyle = .thin
        self.splitView.autosaveName = SidebarSplitViewName
        self.splitView.identifier = SidebarSplitViewName
        self.view = self.splitView
    }
    
    func useSidebarContent(_ view : NSView) {
        for child in sidebarItem.viewController.view.subviews {
            if child != view {
                view.removeFromSuperview()
            }
        }
        sidebarItem.viewController.view.addSubview(view)
        view.addConstraintsMatchingSuperviewBounds()
    }
    
    func useBodyContent(_ view : NSView) {
        for child in contentItem.viewController.view.subviews {
            if child != view {
                child.removeFromSuperview()
            }
        }
        contentItem.viewController.view.addSubview(view)
        view.addConstraintsMatchingSuperviewBounds()
    }
    
    func showSidebar() {
        sidebarItem.animator().isCollapsed = false
    }
    
    func hideSidebar() {
        sidebarItem.animator().isCollapsed = true
    }
    
    var isSidebarVisible : Bool {
        return !sidebarItem.isCollapsed
    }
    
    func toggleSidebar() {
        sidebarItem.animator().isCollapsed = !sidebarItem.isCollapsed
    }

}
