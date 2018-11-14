//
//  TestCell.swift
//  Example Project Swift
//
//  Created by Prince Ugwuh on 10/12/16.
//  Copyright © 2016 MFX Studios. All rights reserved.
//

import UIKit
import DataSource

class TestCell: UICollectionViewCell, DataSourceConfigurable {
    static var identifier: String = "TestCell"
    
    func configure(_ item: Any?) {
        self.backgroundColor = UIColor.red
    }
}


class TestCell2: UITableViewCell, DataSourceConfigurable {
    static var identifier: String = "TestCell2"
    
    func configure(_ item: Any?) {
        self.textLabel?.text = item as? String
    }
}
