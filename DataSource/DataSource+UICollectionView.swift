
import UIKit

extension DataSource: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !self.staticItems.isEmpty {
            return self.staticItems.count
        }
        
        if !self.items.isEmpty {
            return self.items.count
        }
        
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        var item: Any?
        
        if !self.staticItems.isEmpty {
            let staticItem = self.staticItems[indexPath.row]
            identifier = staticItem.identifier
            item = staticItem.item
        } else {
            item = self.item(at: indexPath)
            identifier = self.cellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if cell is DataSourceConfigurable {
            let sourceCell = cell as! DataSourceConfigurable
            sourceCell.configure(item)
            delegate?.didConfigure(sourceCell, at: indexPath)
        }
        
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var  identifier: String = ""
        var item: Any?

        if let headerItem = self.headerItem,
            kind == UICollectionElementKindSectionHeader {
            
            identifier = headerItem.identifier
            item = headerItem.item
        } else if let footerItem = self.footerItem,
            kind == UICollectionElementKindSectionFooter {
            
            identifier = footerItem.identifier
            item = footerItem.item
        }

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)

        if let cell = cell as? DataSourceConfigurable {
            cell.configure(item)
            self.delegate?.didConfigure(cell, at: indexPath)
        }

        return cell
    }
}


extension GroupedDataSource: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSources.isEmpty ? 1 : self.dataSources.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSources[section].collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.dataSources[indexPath.section].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.dataSources[indexPath.section].collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}