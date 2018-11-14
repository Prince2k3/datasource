import UIKit

@objc(MSDataSourceDelegate)
public protocol DataSourceDelegate {
    @objc(dataSource:didConfigureCell:)
    func didConfigure(_ cell: DataSourceConfigurable, at indexPath: IndexPath)
    
    @objc(dataSource:commitEditingStyleForIndexPath:)
    optional func commitEditingStyle(_ editingStyle: UITableViewCellEditingStyle, forIndexPath indexPath: IndexPath)
}

@objc(MSDataSourceConfigurable)
public protocol DataSourceConfigurable {
    @objc(configureItem:)
    func configure(_ item: Any?)
}

@objc(MSDataSourceStaticItem)
open class DataSourceStaticItem: NSObject {
    open var identifier: String = ""
    open var item: Any?
    
    public init(identifier: String, item: Any? = nil) {
        self.identifier = identifier
        self.item = item
    }
}

@objc(MSDataSource)
open class DataSource: NSObject {
    internal var staticItems: [DataSourceStaticItem] = []
    internal(set) var cellIdentifier: String = ""
    
    open weak var delegate: DataSourceDelegate?
    
    open var items: [Any] = []
    open var title: String?
    open var headerItem: DataSourceStaticItem?
    open var footerItem: DataSourceStaticItem?
    open var isEditable: Bool = false
    open var isMovable: Bool = false
    open var editableItems: [IndexPath: NSNumber]? // NSNumber represents the UITableViewCellEditingStyle
    open var movableItems: [IndexPath]?
    open var loadingMoreCellIdentifier: String?
    
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
    
    @objc(itemAtIndexPath:)
    open func item(at indexPath: IndexPath) -> Any? {
        return self.items[indexPath.row]
    }
}

@objc(MSGroupedDataSource)
open class GroupedDataSource: NSObject {
    open weak var delegate: DataSourceDelegate?
    open fileprivate(set) var dataSources: [DataSource] = [] {
        didSet {
            self.dataSources.forEach { $0.delegate = self.delegate }
        }
    }
    
    public convenience init(dataSources: [DataSource]) {
        self.init()
        defer { self.dataSources = dataSources }
    }
    
    @objc(itemAtIndexPath:)
    func item(at indexPath: IndexPath) -> Any? {
        return self.dataSources[indexPath.section].item(at: indexPath)
    }
    
    @objc(sectionTitleAtIndexPath:)
    func sectionTitle(at indexPath: IndexPath) -> String? {
        return self.dataSources[indexPath.section].title
    }
}
