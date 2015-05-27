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
    
    
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var alertNameLabel: UILabel!
    @IBOutlet weak var curveNameLabel: UILabel!
    @IBOutlet weak var riseToThresholdLabel: UILabel!
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func setupWithAlert(alert: Alert, andCurve curve: Curve) {
        /*
        self.backgroundColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        self.alertTitleLabel.textColor = UIColor.whiteColor()
        self.alertDetailLabel.textColor = UIColor.whiteColor()
        */

        self.alertNameLabel.text = "\(alert.name)"
        if alert.rising.boolValue {
            self.riseToThresholdLabel.text = "Alert on rise to \(alert.threshold) (\(curve.units))"
        } else {
            self.riseToThresholdLabel.text = "Alert on fall to \(alert.threshold) (\(curve.units))"
        }
        
        self.curveNameLabel.text = curve.name
        switch alert.priority {
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
    
    class func cellIdentifier() -> String! {
        return "AlertTableViewCell"
    }
    
}