//
//  AlertInboxCell.swift
//  DrillAlert
//
//  Created by Lucas David on 1/19/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertInboxCell: UITableViewCell {
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertInformationLabel: UILabel!
    
    class func cellIdentifier() -> String! {
        return "AlertInboxCell"
    }
    
    func setupWithAlert(alert: Alert!) {
        /*
        self.alertTitleLabel.text = alert.title
        self.alertInformationLabel.text = alert.information
        */
    }
    
}