//
//  DeleteLayoutTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class DeleteDashboardTableViewCell: UITableViewCell {
    @IBOutlet weak var deleteDashboardButton: UIButton!
    class func cellIdentifier() -> String {
        return "DeleteDashboardTableViewCell"
    }
    
    func disable() {
        self.deleteDashboardButton.enabled = false
    }
    
    func enable() {
        self.deleteDashboardButton.enabled = true
    }
}