//
//  ViewControllerGrouper.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa

let ViewControllerGrouperCellIdentifier = "ViewControllerGrouperCellIdentifier"

class NamedGroup<A> {
    var items : [A] = []
    let name : String
    let displayName : String
    
    init(name : String, displayName : String) {
        self.name = name
        self.displayName = displayName;
    }
}

protocol ViewControllerGrouperDelegate : class {
    func controllerGroupSelectedController(controller : NSViewController)
}

class ViewControllerGrouper: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    weak var delegate : ViewControllerGrouperDelegate?
    private var groups : [NamedGroup<NSViewController>] = []

    func addViewController(controller: NSViewController, plugin: Plugin) {
        for group in groups {
            if group.name == plugin.name {
                group.items.append(controller)
                return
            }
        }
        
        let group = NamedGroup<NSViewController>(name: plugin.name, displayName: plugin.displayName)
        group.items = [controller]
        self.groups.append(group)
    }
    
    func removeViewController(controller: NSViewController, plugin: Plugin) {
        for group in groups {
            if group.name == plugin.name {
                group.items = group.items.filter { return $0 != controller }
            }
        }
        groups = groups.filter({ return $0.items.count > 0 })
    }
    
    var hasMultipleItems : Bool {
        if groups.count > 1 {
            return true
        }
        else if groups.count == 1 && groups[0].items.count > 1 {
            return true
        }
        return false
    }
    
    func titleForRow(row : Int) -> String {
        var sum = 0
        for group in groups {
            if sum == row {
                return group.displayName
            }
            sum += 1
            if row < sum + group.items.count {
                let controller = group.items[row - sum]
                return controller.title!
            }
        }
        return ""
    }
    
    func controllerForRow(row : Int) -> NSViewController? {
        var sum = 0
        for group in groups {
            if sum == row {
                return nil
            }
            sum += 1
            if row < sum + group.items.count {
                let controller = group.items[row - sum]
                return controller
            }
        }
        return nil
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var sum = 0
        for group in groups {
            sum += 1 + group.items.count
        }
        return sum;
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(ViewControllerGrouperCellIdentifier, owner: nil) as NSTableCellView
        cell.textField?.stringValue = titleForRow(row)
        return cell
    }
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        var sum = 0
        for group in groups {
            if sum == row {
                return true;
            }
            sum += 1 + group.items.count
        }
        return false;
    }
    
    func tableView(tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: NSIndexSet) -> NSIndexSet {
        let resultSet = NSMutableIndexSet()
        var index = proposedSelectionIndexes.firstIndex
        while index != NSNotFound {
            let groupRow = self.tableView(tableView, isGroupRow: index as Int)
            if !groupRow {
                resultSet.addIndex(index)
            }
            index = proposedSelectionIndexes.indexGreaterThanIndex(index)
        }
        return resultSet
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let tableView = notification.object as NSTableView
        let selection = tableView.selectedRow
        if selection != NSNotFound {
            if let controller = controllerForRow(selection) {
                delegate?.controllerGroupSelectedController(controller)
            }
            
        }
    }

}
