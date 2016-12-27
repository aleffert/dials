//
//  ViewControllerGrouper.swift
//  Dials-Desktop
//
//  Created by Akiva Leffert on 12/9/14.
//
//

import Cocoa
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


let ViewControllerGrouperCellIdentifier = "ViewControllerGrouperCellIdentifier"

private enum Row {
    case singleton(NamedGroup<NSViewController>)
    case heading(NamedGroup<NSViewController>)
    case controller(NSViewController)
}

class NamedGroup<A> {
    var items : [A] = []
    let name : String
    let label : String
    
    init(name : String, label : String) {
        self.name = name
        self.label = label;
    }
}

typealias ViewControllerGroup = NamedGroup<NSViewController>

protocol ViewControllerGrouperDelegate : class {
    func controllerGroupSelectedController(_ controller : NSViewController)
}

class ViewControllerGrouper: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    weak var delegate : ViewControllerGrouperDelegate?
    fileprivate var groups : [ViewControllerGroup] = []
    fileprivate var rows : [Row] = []
    
    fileprivate func buildRowList() -> [Row] {
        var result : [Row] = []
        for group in groups {
            if group.items.count == 1 {
                 result.append(Row.singleton(group))
            }
            else {
                result.append(Row.heading(group))
                result.append(contentsOf: group.items.map{ Row.controller($0) })
            }
        }
        return result
    }

    func addViewController(_ controller: NSViewController, plugin: Plugin) {
        var found = false
        for group in groups {
            if group.name == plugin.identifier {
                group.items.append(controller)
                if plugin.shouldSortChildren {
                    group.items.sort(by: { (left, right) -> Bool in
                        return left.title < right.title
                    })
                }
                found = true
                break
            }
        }
        
        if !found {
            let group = NamedGroup<NSViewController>(name: plugin.identifier, label: plugin.label)
            group.items = [controller]
            groups.append(group)
        }
        groups.sort { (left, right) -> Bool in
            return left.label < right.label
        }
        rows = buildRowList()
    }
    
    func removeViewController(_ controller: NSViewController, plugin: Plugin) {
        for group in groups {
            if group.name == plugin.identifier {
                group.items = group.items.filter { return $0 != controller }
            }
        }
        groups = groups.filter({ return $0.items.count > 0 })
        rows = buildRowList()
    }
    
    var hasMultipleItems : Bool {
        return rows.count > 0
    }
    
    func controllerForRow(_ row : Int) -> NSViewController? {
        let item = rows[row]
        switch item {
        case .heading(_):
            return nil
        case .singleton(let group):
            return group.items[0]
        case .controller(let controller):
            return controller
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: ViewControllerGrouperCellIdentifier, owner: nil) as! NSTableCellView
        let item = rows[row]
        switch item {
        case .heading(let group):
            cell.textField?.stringValue = group.label
        case .singleton(let group):
            cell.textField?.stringValue = group.label
            cell.textField?.font = NSFont.boldSystemFont(ofSize: 11)
        case .controller(let controller):
            cell.textField?.stringValue = controller.title ?? "Item"
            cell.textField?.font = NSFont.systemFont(ofSize: 12)
        }
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let item = rows[row]
        switch item {
        case .singleton(_): fallthrough
        case .heading(_):
            if row == 0 {
                return 20
            }
            else {
                return 24
            }
        case .controller(_):
            return 20
        }
    }
    
    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        let item = rows[row]
        switch item {
        case .singleton(_): return false
        case .heading(_): return true
        case .controller(_): return false
        }
    }
    
    func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
        let resultSet = NSMutableIndexSet()
        var index = proposedSelectionIndexes.first
        while index != nil {
            let groupRow = self.tableView(tableView, isGroupRow: index! as Int)
            if !groupRow {
                resultSet.add(index!)
            }
            index = proposedSelectionIndexes.integerGreaterThan(index!)
        }
        return resultSet as IndexSet
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableView = notification.object as! NSTableView
        let selection = tableView.selectedRow
        if selection != -1 {
            if let controller = controllerForRow(selection) {
                delegate?.controllerGroupSelectedController(controller)
            }
        }
    }
    
    func controllersForRowIndexes(_ indexes : IndexSet) -> [NSViewController] {
        var result : [NSViewController] = []
        for i in 0 ..< rows.count {
            let row = rows[i]
            if indexes.contains(i) {
                switch row {
                case let .singleton(group):
                    result.append(group.items[0])
                case .heading(_):
                    continue
                case let .controller(c):
                    result.append(c)
                }
            }
        }
        return result
    }
    
    func rowIndexesForControllers(_ controllers : [NSViewController]) -> IndexSet {
        let result = NSMutableIndexSet()
        for i in 0 ..< rows.count {
            if let c = controllerForRow(i) {
                if (controllers.index(of: c) != nil) {
                    result.add(i)
                }
            }
        }
        return result as IndexSet
    }
    
    fileprivate func adjacentTabIndex(_ existingIndex : Int, range : [Int]) -> Int {
        for i in range {
            let proposed = (i + existingIndex + rows.count) % rows.count
            let item = rows[proposed]
            switch item {
            case .singleton(_): return proposed
            case .controller(_): return proposed
            case .heading(_): continue
            }
        }
        return existingIndex
    }
    
    func nextTabIndex(_ existingIndex : Int) -> Int {
        return adjacentTabIndex(existingIndex, range : Array(1 ... rows.count))
    }
    
    func previousTabIndex(_ existingIndex : Int) -> Int {
        return adjacentTabIndex(existingIndex, range : Array((0 ..< rows.count).reversed()))
    }

}
