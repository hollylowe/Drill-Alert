//
//  ManageViewsTableViewCell.swift
//  DrillAlert
//
//  Created by Holly Lowe on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

import UIKit

class ManageViewsTableViewCell: UITableViewCell {
    @IBOutlet weak var visualName: UILabel!
    @IBOutlet weak var visualActiveSwitch: UISwitch!
    
    class func getCellIdentifier() -> String! {
        return "ManageViewsTableViewCell"
    }
    
//    func setupWithParameterAlert(parameterAlert: ParameterAlert) {
//        self.parameterAlertName.text = parameterAlert.parameter.name
//        self.accessoryType = .DisclosureIndicator
//        self.parameterAlertSwitch.on = true
//    }
    func setupVisualData(name: String){
        self.visualName.text = name
        self.visualActiveSwitch.on = true
    }
}