//
//  AlertTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertTableViewCell: UITableViewCell {
    
    @IBOutlet weak var alertOnSwitch: UISwitch!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertDetailLabel: UILabel!
    
    func setupWithAlert(alert: Alert) {
        self.alertTitleLabel.text = "\(alert.type.name) Alert, \(alert.priority.description)"
        if alert.alertOnRise {
            self.alertDetailLabel.text = "Alert on rise to \(alert.value) \(alert.type.units)"
        } else {
            self.alertDetailLabel.text = "Alert on fall to \(alert.value) \(alert.type.units)"
        }
    }
    
    class func cellIdentifier() -> String! {
        return "AlertTableViewCell"
    }
    
}