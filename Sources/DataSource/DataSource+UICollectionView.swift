/*
 MIT License
 
 Copyright (c) 2016 Prince Ugwuh
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

extension DataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !self.staticCells.isEmpty {
            return staticCells.count
        } else if let numberOfItems = self.numberOfItems {
            return numberOfItems
        } else if !items.isEmpty {
            return loadingMoreCellIdentifier != nil ? items.count + 1 : items.count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !staticCells.isEmpty {
            guard
                let staticCell = staticCells[indexPath.row] as? UICollectionViewCell
                else { fatalError("cell is not of type UICollectionViewCell") }
            
            if let cell = staticCell as? DataSourceConfigurable {
                cell.configure(item)
                delegate?.didConfigure(cell, at: indexPath)
            }
            
            return staticCell
        }
        
        let identifier: String
        var item: Any?
        
        if let loadingMoreCellIdentifier = self.loadingMoreCellIdentifier, items.count == indexPath.row {
            identifier = loadingMoreCellIdentifier
        } else {
            item = items[indexPath.row]
            identifier = cellIdentifier
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if cell is DataSourceConfigurable {
            let sourceCell = cell as! DataSourceConfigurable
            sourceCell.configure(item)
            delegate?.didConfigure(sourceCell, at: indexPath)
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var  identifier: String = ""
        var item: Any?

        if let headerView = self.headerView,
            kind == UICollectionView.elementKindSectionHeader {
            
            identifier = headerView.identifier
            item = headerView.item
        } else if let footerView = self.footerView,
            kind == UICollectionView.elementKindSectionFooter {
            
            identifier = footerView.identifier
            item = footerView.item
        }

        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)

        if let cell = cell as? DataSourceConfigurable {
            cell.configure(item)
            delegate?.didConfigure(cell, at: indexPath)
        }

        return cell
    }
}


extension GroupedDataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSources.isEmpty ? 1 : dataSources.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources[section].collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSources[indexPath.section].collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return dataSources[indexPath.section].collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: indexPath)
    }
}
