//
//  CanvasItemDataSourceTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CanvasItemDataSourceTableViewCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "CanvasItemDataSourceTableViewCell"
    }
    
    func setupWithCanvasItemDataSource(dataSource: CanvasItemDataSource) {
        if let label = self.textLabel {
            label.text = dataSource.getTitle()
        }
    }
}