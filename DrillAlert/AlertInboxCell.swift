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
    
    @IBOutlet weak var priorityImageView: UIImageView!
  
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
        } else if let dateString = alertHistoryItem.dateString {
            self.alertTimeLabel.text = dateString
        } else {
            self.alertTimeLabel.text = "Unknown Time"
        }
        
        if let priority = alertHistoryItem.priority {
            switch priority {
            case .Critical:
                if let image = UIImage(named: "Critical Alert Icon") {
                    self.priorityImageView.image = self.imageWithImage(image, scaledToSize: CGSize(width: 30.0, height: 30.0))
                }
            case .Warning:
                if let image = UIImage(named: "Warning Alert Icon") {
                    self.priorityImageView.image = self.imageWithImage(image, scaledToSize: CGSize(width: 30.0, height: 30.0))
                }
            case .Information:
                if let image = UIImage(named: "Information Alert Icon") {
                    self.priorityImageView.image = self.imageWithImage(image, scaledToSize: CGSize(width: 30.0, height: 30.0))
                }
            default: break
            }
        }
        self.selectionStyle = .None

    }
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func getDateString(date: NSDate) -> String {
        var dateString = ""
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/dd/yy h:mm a"
        return dateFormatter.stringFromDate(date)
    }
}