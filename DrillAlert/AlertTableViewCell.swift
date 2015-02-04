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
        /*
        self.backgroundColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        self.alertTitleLabel.textColor = UIColor.whiteColor()
        self.alertDetailLabel.textColor = UIColor.whiteColor()
        */
        self.alertOnSwitch.onTintColor = UIColor(red: 0.604, green: 0.792, blue: 1.0, alpha: 1.0)

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