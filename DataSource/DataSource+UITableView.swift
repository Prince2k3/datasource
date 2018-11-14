
import UIKit

extension DataSource: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.staticItems.isEmpty {
            return self.staticItems.count
        }
        
        if !self.items.isEmpty {
            if self.loadingMoreCellIdentifier != nil {
                return self.items.count + 1
            }
            
            return self.items.count
        }
        
        return 0
    }
    
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if self.isMovable {
            if let movableItems = self.movableItems {
                return movableItems.contains(indexPath)
            } else {
                return true // all
            }
        }
        
        return false
    }
    
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.isEditable {
            if let editableItems = self.editableItems {
                return editableItems.keys.contains(indexPath)
            } else {
                return true // all
            }
        }
        return false
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.delegate?.commitEditingStyle?(editingStyle, forIndexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.items[sourceIndexPath.row]
        self.items.remove(at: sourceIndexPath.row)
        self.items.insert(item, at: destinationIndexPath.row)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier: String?
        var item: Any?
        
        if let loadingMoreCellIdentifier = self.loadingMoreCellIdentifier,
            self.items.count == indexPath.row {
            identifier = loadingMoreCellIdentifier
        } else if self.staticItems.count > 0 {
            let staticItem = self.staticItems[indexPath.row]
            identifier = staticItem.identifier
            item = staticItem.item
        } else {
            item = self.items[indexPath.row]
            identifier = self.cellIdentifier
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath)
        
        if let cell = cell as? DataSourceConfigurable {
            cell.configure(item)
            self.delegate?.didConfigure(cell, at: indexPath)
        }
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.title
    }
}

extension GroupedDataSource: UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        guard
            !self.dataSources.isEmpty
            else { return 1 }
        return self.dataSources.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources[section].tableView(tableView, numberOfRowsInSection: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dataSources[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSources[section].tableView(tableView, titleForHeaderInSection:section)
    }
}
