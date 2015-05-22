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
    
    func setupWithAlertHistoryItem(alertHistoryItem: AlertHistoryItem!) {
        
        if let priority = alertHistoryItem.priority {
            self.alertTitleLabel.text = priority.toString()
        }
        
        self.alertInformationLabel.text = alertHistoryItem.getNotificationBody()
        
        if let date = alertHistoryItem.date {
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