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

public protocol DataSourceDelegate: class {
    func didConfigure(_ cell: DataSourceConfigurable, at indexPath: IndexPath)
}

public protocol DataSourceEditingStyleDelegate: class {
    func commitEditingStyle(_ editingStyle: UITableViewCell.EditingStyle, for indexPath: IndexPath)
}

public protocol DataSourceConfigurable {
    func configure(_ item: Any?)
}

public protocol DataSourceStaticCell: UIView {
    var identifier: String { get }
    var item: Any? { get set }
}

public final class DataSource: NSObject {
    var cellIdentifier: String = ""
    
    public weak var delegate: DataSourceDelegate?
    public weak var editingStyleDelegate: DataSourceEditingStyleDelegate?
    
    public var staticCells: [DataSourceStaticCell] = []
    public var items: [Any] = []
    public var numberOfItems: Int?
    public var title: String?
    public var headerView: DataSourceStaticCell?
    public var footerView: DataSourceStaticCell?
    public var isEditable: Bool = false
    public var isMovable: Bool = false
    public var editableCells: [IndexPath: UITableViewCell.EditingStyle] = [:]
    public var movableCellIndexPaths: [IndexPath] = []
    public var loadingMoreCellIdentifier: String?
    
    public convenience init(staticCells: [DataSourceStaticCell]) {
        self.init()
        self.staticCells = staticCells
    }
    
    public convenience init(cellIdentifier: String, items: [Any] = []) {
        self.init()
        self.cellIdentifier = cellIdentifier
        self.items = items
    }
    
    public func item(at indexPath: IndexPath) -> Any? {
        return items[indexPath.row]
    }
}

public final class GroupedDataSource: NSObject {
    public weak var delegate: DataSourceDelegate? {
        didSet {
            dataSources.forEach { $0.delegate = self.delegate }
        }
    }
    
    public private(set) var dataSources: [DataSource] = []
    
    public convenience init(dataSources: [DataSource]) {
        self.init()
        dataSources.forEach { $0.delegate = self.delegate }
        self.dataSources = dataSources
        
    }
    
    public func item(at indexPath: IndexPath) -> Any? {
        return dataSources[indexPath.section].item(at: indexPath)
    }
    
    public func sectionTitle(at indexPath: IndexPath) -> String? {
        return dataSources[indexPath.section].title
    }
}
