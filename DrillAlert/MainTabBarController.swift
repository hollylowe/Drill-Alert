//
//  MainTabBarController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/26/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var currentUser: User!
    
    let homeIndex = 0
    let settingsIndex = 1
    let adminIndex = 2
    
    override func viewDidLoad() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.navigationItem.hidesBackButton = true
        self.delegate = self
        if let viewControllers = self.viewControllers {
            let homeViewController = viewControllers[homeIndex] as HomeViewController
            let settingsViewController = viewControllers[settingsIndex] as SettingsTableViewController
            
            homeViewController.currentUser = currentUser
            settingsViewController.currentUser = currentUser
            self.selectedIndex = 0
            
            if self.selectedIndex == homeIndex {
                self.navigationItem.title = "Home"
            } else if self.selectedIndex == settingsIndex {
                self.navigationItem.title = "Settings"
            }
            
            if currentUser.isAdmin {
                let adminViewController = viewControllers[adminIndex] as AdminTableViewController
                adminViewController.currentUser = currentUser
                if self.selectedIndex == adminIndex {
                    self.navigationItem.title = "Admin"
                }
                
                self.setViewControllers([homeViewController, settingsViewController, adminViewController], animated: false)
            } else {
                self.setViewControllers([homeViewController, settingsViewController], animated: false)
            }
            
            setupTabBarIcons()
        }
        
        super.viewDidLoad()
    }
    
    func setupTabBarIcons() {
        let tabBar = self.tabBar
        let lightBlueColor = UIColor(red: 0.412, green: 0.671, blue: 0.898, alpha: 1.0)
        tabBar.tintColor = UIColor.whiteColor()
        tabBar.selectedImageTintColor = lightBlueColor
        if let items = tabBar.items {
            let homeTabBarItem = items[homeIndex] as UITabBarItem
            let settingsTabBarItem = items[settingsIndex] as UITabBarItem
            let imageSize = CGSizeMake(30, 30)
            
            // Home tab bar icon
            if let homeSelectedIcon = UIImage(named: "home_full.png") {
                homeTabBarItem.selectedImage = imageWithImage(homeSelectedIcon, scaledToSize: imageSize)
            }
            
            if let homeDefaultIcon = UIImage(named: "home_line.png") {
                homeTabBarItem.image = imageWithImage(homeDefaultIcon, scaledToSize: imageSize)
            }
            
            // Settings tab bar icon
            if let settingsSelectedIcon = UIImage(named: "settings_full.png") {
                settingsTabBarItem.selectedImage = imageWithImage(settingsSelectedIcon, scaledToSize: imageSize)
                
            }
            
            if let settingsDefaultIcon = UIImage(named: "settings_line.png") {
                settingsTabBarItem.image = imageWithImage(settingsDefaultIcon, scaledToSize: imageSize)
            }
            
            if currentUser.isAdmin {
                // Admin tab bar icon
                let adminTabBarItem = items[adminIndex] as UITabBarItem
                if let adminSelectedIcon = UIImage(named: "admin_full.png") {
                    adminTabBarItem.selectedImage = imageWithImage(adminSelectedIcon, scaledToSize: imageSize)
                    
                }
                
                if let adminDefaultIcon = UIImage(named: "admin_line.png") {
                    adminTabBarItem.image = imageWithImage(adminDefaultIcon, scaledToSize: imageSize)
                }
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

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {

        if self.selectedIndex == homeIndex {
            self.navigationItem.title = "Home"
        } else if self.selectedIndex == settingsIndex {
            self.navigationItem.title = "Settings"
        } else if self.selectedIndex == adminIndex {
            self.navigationItem.title = "Admin"
        }
    }
}