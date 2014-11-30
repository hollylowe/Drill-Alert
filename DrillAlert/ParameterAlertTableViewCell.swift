//
//  AlertTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 11/29/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ParameterAlertTableViewCell: UITableViewCell {
    @IBOutlet weak var parameterAlertName: UILabel!
    @IBOutlet weak var parameterAlertSwitch: UISwitch!
    
    class func getCellIdentifier() -> String! {
        return "ParameterAlertTableViewCell"
    }
    
    func setupWithParameterAlert(parameterAlert: ParameterAlert) {
        self.parameterAlertName.text = parameterAlert.parameter.name
        self.accessoryType = .DisclosureIndicator
        self.parameterAlertSwitch.on = true
    }
}