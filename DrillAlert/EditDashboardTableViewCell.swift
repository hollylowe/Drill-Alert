//
//  EditLayoutTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/24/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class EditDashboardTableViewCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "EditDashboardTableViewCell"
    }
    
    func setupWithDashboard(dashboard: Dashboard) {
        if let label = self.textLabel {
            label.text = dashboard.name
        }
    }
}