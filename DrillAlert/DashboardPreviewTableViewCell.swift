//
//  DashboardPreviewTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/26/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class DashboardPreviewTableViewCell: UITableViewCell {
    @IBOutlet weak var dashboardNameLabel: UILabel!
    
    @IBOutlet weak var dashboardPreviewView: UIView!
    
    let maxPages = 4
    class func cellIdentifier() -> String {
        return "DashboardPreviewTableViewCell"
    }
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func addPageImages(pages: Array<Page>) {
        var pageIndex = 0
        var nextImageX: CGFloat = 0.0
        var width: CGFloat = 22.0
        var height: CGFloat = 22.0
        var padding: CGFloat = 10.0
        var imageSize = CGSize(width: 22.0, height: 22.0)
        for page in pages {
            if pageIndex <= self.maxPages {
                if pageIndex == 0 {
                    nextImageX = 0
                } else {
                    nextImageX = CGFloat(pageIndex) * width + padding
                }
                var rect = CGRectMake(nextImageX,
                    0,
                    width,
                    22.0)
                var newImageView = UIImageView(frame: rect)
                switch page.type {
                case .Canvas:
                    if let image = UIImage(named: "canvas-icon-color") {
                        newImageView.image = self.imageWithImage(image, scaledToSize: imageSize)
                    }
                case .Plot:
                    if let image = UIImage(named: "plot-icon-color") {
                        newImageView.image = self.imageWithImage(image, scaledToSize: imageSize)
                    }
                case .Compass:
                    if let image = UIImage(named: "compass-icon-color") {
                        newImageView.image = self.imageWithImage(image, scaledToSize: imageSize)
                    }
                default: break
                }
                self.dashboardPreviewView.addSubview(newImageView)
                pageIndex++
            } else {
                break;
            }
            
        }
    }
    
    func setupWithDashboard(dashboard: Dashboard) {
        self.dashboardNameLabel.text = dashboard.name
        
        if dashboard.pages.count > 0 {
            self.addPageImages(dashboard.pages)
        } else {
            var noPagesLabel = UILabel(frame: CGRectMake(0, 0, self.dashboardPreviewView.frame.size.width, self.dashboardPreviewView.frame.size.height))
            noPagesLabel.text = "No Pages"
            noPagesLabel.textColor = UIColor(white: 0.52, alpha: 1.0)
            noPagesLabel.font = UIFont(name: "HelveticaNeue", size: 11.0)
            self.dashboardPreviewView.addSubview(noPagesLabel)
        }
        /*
        var borderView = UIView(frame: CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1.0))
        borderView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        self.addSubview(borderView)
        */
    }
        
    
}