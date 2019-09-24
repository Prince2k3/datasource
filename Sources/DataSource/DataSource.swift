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

public protocol DataSourceConfigurable {
    associatedtype CellData
    func configure(_ data: CellData?)
}

public final class DataSource<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable, Configurable: DataSourceConfigurable>: NSObject where Configurable.CellData == ItemIdentifierType {
    public typealias TableViewCellProvider = (UITableView, IndexPath, ItemIdentifierType) -> UITableViewCell?
    public typealias CollectionViewCellProvider = (UICollectionView, IndexPath, ItemIdentifierType) -> UICollectionViewCell?
    public typealias SupplementaryViewProvider = (UICollectionView, String, IndexPath) -> UICollectionReusableView?
    
    public var commitEditingStyle: ((UITableViewCell.EditingStyle, IndexPath) -> Void)?
    
    private var tableViewCellProvider: TableViewCellProvider?
    private var collectionViewCellProvider: CollectionViewCellProvider?
    private var supplementaryViewProvider: SupplementaryViewProvider?
    private var sections: [SectionIdentifierType] = []
    
    public var items: [SectionIdentifierType: [ItemIdentifierType]] = [:]
    public var numberOfItems: Int?
    public var isCellsEditable: Bool = false
    public var isCellsMovable: Bool = false
    public var editableCells: [IndexPath: UITableViewCell.EditingStyle] = [:]
    public var movableCellIndexPaths: [IndexPath] = []

    public convenience init(collectionViewCellProvider: @escaping CollectionViewCellProvider, supplementaryViewProvider: SupplementaryViewProvider? = nil) {
        self.init()
        self.collectionViewCellProvider = collectionViewCellProvider
        self.supplementaryViewProvider = supplementaryViewProvider
    }
    
    public convenience init(tableViewCellProvider: @escaping TableViewCellProvider) {
        self.init()
        self.tableViewCellProvider = tableViewCellProvider
    }
    
    // UITableView
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfItems = self.numberOfItems {
            return numberOfItems
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if isCellsMovable {
            return !movableCellIndexPaths.isEmpty ? movableCellIndexPaths.contains(indexPath) : true
        }
        
        return false
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isCellsEditable {
            if !editableCells.isEmpty {
                return editableCells.keys.contains(indexPath)
            } else {
                return true // all
            }
        }
        return false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        commitEditingStyle?(editingStyle, indexPath)
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var sourceItems = items[sections[sourceIndexPath.section]] ?? []
        let item = sourceItems.remove(at: sourceIndexPath.row)
        items[sections[sourceIndexPath.section]] = sourceItems
        
        
        var destinationItems = items[sections[destinationIndexPath.section]] ?? []
        destinationItems.insert(item, at: destinationIndexPath.row)
        items[sections[destinationIndexPath.section]] = destinationItems
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let item = items[sections[indexPath.section]]?[indexPath.row],
            let tableViewCellProvider = self.tableViewCellProvider,
            let cell = tableViewCellProvider(tableView, indexPath, item)
            else { fatalError("must define a 'UITableViewCell'") }
        return cell
    }
    
    // UICollectionView
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItems = self.numberOfItems {
            return numberOfItems
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let item = items[sections[indexPath.section]]?[indexPath.row],
            let collectionViewCellProvider = self.collectionViewCellProvider,
            let cell = collectionViewCellProvider(collectionView, indexPath, item)
            else { fatalError("must define a 'UICollectionViewCell'") }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            let view = supplementaryViewProvider?(collectionView, kind, indexPath)
            else { fatalError("Reusable view not defined") }
        return view
    }
}
