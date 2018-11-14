//
//  SecondViewController.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit
import DataSource

class ViewController2: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.identifier)
        
        build()
    }

    func build() {
        var items = [DataSourceStaticItem]()
        for _ in 0..<100 {
            items.append(DataSourceStaticItem(identifier: TestCell.identifier, item: nil))
        }
        self.dataSource = DataSource(staticItems: items)
        self.collectionView.dataSource = self.dataSource
    }
}

