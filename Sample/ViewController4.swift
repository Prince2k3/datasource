//
//  ViewController4.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit
import DataSource

class ViewController4: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(TestCell2.self, forCellReuseIdentifier: TestCell2.identifier)
        
        build()
    }
    
    func build() {
        var items = [DataSourceStaticItem]()
        for i in 0..<100 {
            items.append(DataSourceStaticItem(identifier: TestCell2.identifier, item: "\(i)"))
        }
        self.dataSource = DataSource(staticItems: items)
        self.tableView.dataSource = self.dataSource
    }
}
