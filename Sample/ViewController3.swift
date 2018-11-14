//
//  ViewController3.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit
import DataSource

class ViewController3: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sampleData: [String] = ["Bananas", "Apples", "Oranges", "Grapes", "Strawberry", "Pineapple", "Mango"]
    var dataSource: DataSource = DataSource(cellIdentifier: TestCell2.identifier)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(TestCell2.self, forCellReuseIdentifier: TestCell2.identifier)
        self.dataSource.items = self.sampleData
        self.tableView.dataSource = self.dataSource
        self.dataSource.title = "Fruits"
    }
}

