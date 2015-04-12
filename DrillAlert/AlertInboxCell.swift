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
    @IBOutlet weak var alertTimeLabel: UILabel!
    
    class func cellIdentifier() -> String! {
        return "AlertInboxCell"
    }
    
    func setupWithAlertNotification(alertNotification: AlertNotification!) {
        /*
        if let alertType = alertNotification.alert.getAlertType() {
            self.alertTitleLabel.text = alertType.name
        }
        */
        if let severity = alertNotification.severity {
            self.alertTitleLabel.text = severity.toString()
        }
        
        self.alertInformationLabel.text = alertNotification.getNotificationBody()
        
        if let date = alertNotification.date {
            self.alertTimeLabel.text = self.getDateString(date)
        }
        self.selectionStyle = .None

    }
    
    func getDateString(date: NSDate) -> String {
        var dateString = ""
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/yy h:mm a"
        return dateFormatter.stringFromDate(date)
    }
}