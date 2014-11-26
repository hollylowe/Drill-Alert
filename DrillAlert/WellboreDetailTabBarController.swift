//
//  WellDetailTabBarController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/4/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class WellboreDetailTabBarController: UITabBarController {
    // Implicit - set by the previous view controller
    var currentWellbore: Wellbore!
    
    let visualsIndex = 0
    let alertsIndex = 1
    override func viewDidLoad() {
        self.title = currentWellbore.name
        setupTabBarIcons()
        super.viewDidLoad()
    }
    
    func setupTabBarIcons() {
        let tabBar = self.tabBar
        if let items = tabBar.items {
            let visualsTabBarItem = items[visualsIndex] as UITabBarItem
            let alertsTabBarItem = items[alertsIndex] as UITabBarItem
            let imageSize = CGSizeMake(30, 30)
            // comment
            if let visualsSelectedIcon = UIImage(named: "graph_full.png") {
                visualsTabBarItem.selectedImage = imageWithImage(visualsSelectedIcon, scaledToSize: imageSize)
            }
            
            if let visualsDefaultIcon = UIImage(named: "graph_line.png") {
                visualsTabBarItem.image = imageWithImage(visualsDefaultIcon, scaledToSize: imageSize)
            }
            
            if let alertsSelectedIcon = UIImage(named: "attention_full.png") {
                alertsTabBarItem.selectedImage = imageWithImage(alertsSelectedIcon, scaledToSize: imageSize)
            }
            
            if let alertsDefaultIcon = UIImage(named: "attention_line.png") {
                alertsTabBarItem.image = imageWithImage(alertsDefaultIcon, scaledToSize: imageSize)
            }
            
        }
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}