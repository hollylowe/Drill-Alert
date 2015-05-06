//
//  ViewTableViewCell.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/15/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    func setupWithDashboard(dashboard: Dashboard) {
        if let label = self.textLabel {
            label.text = "\(dashboard.name)"
        }
    }
    
    class func cellIdentifier() -> String! {
        return "DashboardTableViewCell"
    }
    
}