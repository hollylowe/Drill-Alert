//
//  AlertPriorityCell.swift
//  DrillAlert
//
//  Created by Lucas David on 12/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertPriorityCell: UITableViewCell {
    @IBOutlet weak var alertPriorityLabel: UILabel!
    
    class func getCellIdentifier() -> String! {
        return "AlertPriorityCell"
    }
}