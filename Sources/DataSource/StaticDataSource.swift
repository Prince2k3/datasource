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

public protocol DataSourceStaticCell {}

public final class StaticDataSource<SectionIdentifierType: Hashable>: NSObject, UITableViewDataSource, UICollectionViewDataSource {
    public typealias SupplementaryViewProvider = (UICollectionView, String, IndexPath) -> UICollectionReusableView?
    
    private var supplementaryViewProvider: SupplementaryViewProvider?
    private var sections: [SectionIdentifierType] = []
    
    public var staticCells: [SectionIdentifierType: [DataSourceStaticCell]] = [:]
    
    public convenience init(sections: [SectionIdentifierType], supplementaryViewProvider: SupplementaryViewProvider? = nil) {
        self.init()
        self.supplementaryViewProvider = supplementaryViewProvider
        self.sections = sections
    }
    
    // UITableView
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return staticCells.keys.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !staticCells.isEmpty ? staticCells.count : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            !staticCells.isEmpty,
            let staticCell = staticCells[sections[indexPath.section]]?[indexPath.row] as? UITableViewCell
            else { fatalError("static cell is not of type 'UITableViewCell'") }
        return staticCell
    }
    
    // UICollectionView
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return staticCells.keys.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return !self.staticCells.isEmpty ? staticCells.count : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            !staticCells.isEmpty,
            let staticCell = staticCells[sections[indexPath.section]]?[indexPath.row] as? UICollectionViewCell
            else { fatalError("static cell is not of type 'UICollectionViewCell'") }
        
        return staticCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            let view = supplementaryViewProvider?(collectionView, kind, indexPath)
            else { fatalError("Reusable view not defined") }
        return view
    }
}
