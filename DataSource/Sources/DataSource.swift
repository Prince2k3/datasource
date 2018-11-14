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

open class DataSourceStaticItem: NSObject {
    open var identifier: String = ""
    open var item: Any?
    
    public init(identifier: String, item: Any? = nil) {
        self.identifier = identifier
        self.item = item
    }
}

public final class DataSource: NSObject {
    internal var staticItems: [DataSourceStaticItem] = []
    internal(set) var cellIdentifier: String = ""
    
    public weak var delegate: DataSourceDelegate?
    public weak var editingStyleDelegate: DataSourceEditingStyleDelegate?
    
    public var items: [Any] = []
    public var title: String?
    public var headerItem: DataSourceStaticItem?
    public var footerItem: DataSourceStaticItem?
    public var isEditable: Bool = false
    public var isMovable: Bool = false
    public var editableItems: [IndexPath: NSNumber]? // NSNumber represents the UITableViewCellEditingStyle
    public var movableItems: [IndexPath]?
    public var loadingMoreCellIdentifier: String?
    
    override init() {
        super.init()
    }
    
    public convenience init(staticItems: [DataSourceStaticItem]) {
        self.init()
        self.staticItems = staticItems
    }
    
    public convenience init(cellIdentifier: String, items: [Any] = []) {
        self.init()
        self.cellIdentifier = cellIdentifier
        self.items = items
    }
    
    public func item(at indexPath: IndexPath) -> Any? {
        return self.items[indexPath.row]
    }
}

public final class GroupedDataSource: NSObject {
    public weak var delegate: DataSourceDelegate?
    
    public fileprivate(set) var dataSources: [DataSource] = [] {
        didSet {
            self.dataSources.forEach { $0.delegate = self.delegate }
        }
    }
    
    public convenience init(dataSources: [DataSource]) {
        self.init()
        defer { self.dataSources = dataSources }
    }
    
    public func item(at indexPath: IndexPath) -> Any? {
        return self.dataSources[indexPath.section].item(at: indexPath)
    }
    
    public func sectionTitle(at indexPath: IndexPath) -> String? {
        return self.dataSources[indexPath.section].title
    }
}
