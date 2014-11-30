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
        self.wellNameLabel.text = wellbore.well.name
        self.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        self.selectionStyle = .None
    }
}