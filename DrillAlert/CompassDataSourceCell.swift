//
//  CompassDataSourceCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CompassDataSourceCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "CompassDataSourceCell"
    }
    
    func setupWithDataSource(dataSource: CompassDataSource) {
        if let label = self.textLabel {
            label.text = dataSource.getTitle()
        }
    }
}