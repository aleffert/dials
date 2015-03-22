//
//  ViewControllerGrouper.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa

let ViewControllerGrouperCellIdentifier = "ViewControllerGrouperCellIdentifier"

private enum Row {
    case Singleton(NamedGroup<NSViewController>)
    case Heading(NamedGroup<NSViewController>)
    case Controller(NSViewController)
}

class NamedGroup<A> {
    var items : [A] = []
    let name : String
    let displayName : String
    
    init(name : String, displayName : String) {
        self.name = name
        self.displayName = displayName;
    }
}

typealias ViewControllerGroup = NamedGroup<NSViewController>

protocol ViewControllerGrouperDelegate : class {
    func controllerGroupSelectedController(controller : NSViewController)
}

class ViewControllerGrouper: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    weak var delegate : ViewControllerGrouperDelegate?
    private var groups : [ViewControllerGroup] = []
    private var rows : [Row] = []
    
    private func buildRowList() -> [Row] {
        var result : [Row] = []
        for group in groups {
            if group.items.count == 1 {
                 result.append(Row.Singleton(group))
            }
            else {
                result.append(Row.Heading(group))
                result.extend(group.items.map{ Row.Controller($0) })
            }
        }
        return result
    }

    func addViewController(controller: NSViewController, plugin: Plugin) {
        for group in groups {
            if group.name == plugin.name {
                group.items.append(controller)
                if plugin.shouldSortChildren {
                    group.items.sort({ (left, right) -> Bool in
                        return left.title < right.title
                    })
                }
                rows = buildRowList()
                return
            }
        }
        
        let group = NamedGroup<NSViewController>(name: plugin.name, displayName: plugin.displayName)
        group.items = [controller]
        groups.append(group)
        rows = buildRowList()
    }
    
    func removeViewController(controller: NSViewController, plugin: Plugin) {
        for group in groups {
            if group.name == plugin.name {
                group.items = group.items.filter { return $0 != controller }
            }
        }
        groups = groups.filter({ return $0.items.count > 0 })
        rows = buildRowList()
    }
    
    var hasMultipleItems : Bool {
        return rows.count > 0
    }
    
    func titleForRow(row : Int) -> String {
        let item = rows[row]
        switch(item) {
        case .Heading(let group): return group.displayName
        case .Singleton(let group): return group.displayName
        case .Controller(let controller): return controller.title!
        }
    }
    
    func controllerForRow(row : Int) -> NSViewController? {
        let item = rows[row]
        switch(item) {
        case .Heading(let group): return nil
        case .Singleton(let group): return group.items[0]
        case .Controller(let controller): return controller
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return rows.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeViewWithIdentifier(ViewControllerGrouperCellIdentifier, owner: nil) as NSTableCellView
        cell.textField?.stringValue = titleForRow(row)
        return cell
    }
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        let item = rows[row]
        switch(item) {
        case .Singleton(_): return true
        case .Heading(_): return true
        case .Controller(_): return false
        }
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
    
    private func adjacentTabIndex(existingIndex : Int, range : [Int]) -> Int {
        var index = existingIndex
        for i in range {
            let proposed = (i + existingIndex + rows.count) % rows.count
            let item = rows[proposed]
            switch(item) {
            case .Controller(_): return proposed
            default: continue
            }
        }
        return existingIndex
    }
    
    func nextTabIndex(existingIndex : Int) -> Int {
        return adjacentTabIndex(existingIndex, range : Array(1 ... rows.count))
    }
    
    func previousTabIndex(existingIndex : Int) -> Int {
        return adjacentTabIndex(existingIndex, range : reverse(0 ..< rows.count))
    }

}
