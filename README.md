# DataSource
UITableView and UICollectionView DataSource Class written in Swift that help remove repetitive code when is come to datasource management, keeping the view controller light

## Working with UITableView
Note: If you are using UITableViewCell as a nib file, be sure to register the cell to the table view you are using. Otherwise you won't see the cell.

To use DataSource you'll need to initialize it and give it your UITableViewCell identifier. Once you have done that set the UITableView dataSource be set to the TableViewDataSource dataSource property. 
```Swift
   @IBOutlet weak var tableView: UITableView! {
     didSet {
       self.tableView?.dataSource = self.dataSource
     }
   }

  let dataSource: DataSource = DataSource(cellIdentifier: "<YourCellIdentifier>")
```
In your UITableViewCell add this protocol `DataSourceConfigurable`. (I recommend that this be an extension to keep your cell and how your cell is configured separate.)
```Swift
extension MyTableViewCell: DataSourceConfigurable {
   func configure(_ data: Any?) {
       /// setup your cell here     
   }  
}
```

## Building UITableViewCells from scratch

```Swift
var items: [String] = ["Apples", "Oranges", "Grapes", "Bannanas"]
...
func buildTable() {
  var cellItems = [DataSourceStaticItem]()
  for item in items {
    let cellItem = DataSourceStaticItem()
    cellItem.identifier = "<YourCellIdentifier>"
    cellItem.item = item
    cellItems.append(cellItem)
  }
  
  self.dataSource = DataSource(cellItems: cellItems)
  self.tableView.dataSource = self.dataSource
  self.tableView.reloadData()
} 
...
```
## Working with UITableView sections
```Swift
var items: [String] = ["Apples", "Oranges", "Grapes", "Bannanas"]
...
func buildTable() {
  var dataSources = [DataSourceStaticItem]()
  var cellItems = [DataSourceStaticItem]()
  for item in items {
    let cellItem = DataSourceStaticItem()
    cellItem.identifier = "<YourCellIdentifier>"
    cellItem.item = item
    cellItems.append(cellItem)
  }
  
  for i in 0..<3 {
    let dataSource = DataSource(cellItems: cellItems)
    dataSources.append(dataSource)
  }
  
  self.sectionDataSource = GroupedDataSource(dataSources: dataSources)
  self.tableView.dataSource = self.sectionDataSource
  self.tableView.reloadData()
} 
...
```
## Working Static UITableViewController
With the same setup you can manage dynamic cells within static tableviews. 

Example coming soon

## UICollectionView
DataSource works the exact same for UITableView. Just set DataSource as your DataSource!

## Indexing setup
coming soon

## Moving and Deleting Cells
coming soon

## Installation

##### Carthage 
just add to your Cartfile:
```
github "Prince2k3/datasource"
```
Then import the library in all files where you use it:
```
import DataSource
```
