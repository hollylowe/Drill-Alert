//
//  HomeTabBarController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/26/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class HomeTabBarController: UITabBarController {
    var user: User!
    
    class func storyboardIdentifier() -> String {
        return "HomeTabBarController"
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func viewDidLoad() {
        // Disable the back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .Plain,
            target: nil,
            action: nil)
        self.navigationItem.hidesBackButton = true
        if let image = UIImage(named: "logouticon.png") {
            let logoutImage = imageWithImage(image, scaledToSize: CGSize(width: 40, height: 40))
            let button = UIBarButtonItem(image: logoutImage, style: .Plain, target: self, action: "logoutButtonTapped:")
            self.navigationItem.leftBarButtonItem = button
        } else {
            let button = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutButtonTapped:")
            self.navigationItem.leftBarButtonItem = button

        }
        
        
        
        super.viewDidLoad()
    }
    
    func logoutButtonTapped(sender: UIBarButtonItem) {
        self.user.logout { (loggedOut) -> Void in
            if loggedOut {
                if let navigationController = self.navigationController {
                    navigationController.popToRootViewControllerAnimated(true)
                }
            }
        }
    }
    
    
}