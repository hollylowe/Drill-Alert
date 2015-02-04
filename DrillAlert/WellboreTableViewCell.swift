//
//  WellboreTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 11/29/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class WellboreTableViewCell: UITableViewCell {

    @IBOutlet weak var wellboreNameLabel: UILabel!
    @IBOutlet weak var wellNameLabel: UILabel!

    class func getCellIdentifier() -> String! {
        return "WellboreTableViewCell"
    }
    
    func setupWithWellbore(wellbore: Wellbore!) {
        self.wellboreNameLabel.text = wellbore.name
        self.wellNameLabel.text = wellbore.well.name + ", " + wellbore.well.location
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        self.selectionStyle = .None
        // self.backgroundColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        // self.wellboreNameLabel.textColor = UIColor.whiteColor()
        //  self.wellNameLabel.textColor = UIColor.whiteColor()
    }
}