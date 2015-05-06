//
//  LayoutNameInputTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class DashboardNameInputTableViewCell: UITableViewCell {
    @IBOutlet weak var dashboardNameTextField: UITextField!
    class func cellIdentifier() -> String! {
        return "DashboardNameInputTableViewCell"
    }
}