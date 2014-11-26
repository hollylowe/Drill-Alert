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
    
    override func viewDidLoad() {
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
                
                // Add an admin button if need be.
                if currentUser.isAdmin {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                        title: "Admin",
                        style: UIBarButtonItemStyle.Plain,
                        target: homeViewController,
                        action: "adminBarButtonTapped:")
                }
            } else if self.selectedIndex == settingsIndex {
                self.navigationItem.title = "Settings"
                self.navigationItem.rightBarButtonItem = nil
            }
            
            setupTabBarIcons()
        }
        
        super.viewDidLoad()
    }
    
    func setupTabBarIcons() {
        let tabBar = self.tabBar
        if let items = tabBar.items {
            let homeTabBarItem = items[homeIndex] as UITabBarItem
            let settingsTabBarItem = items[settingsIndex] as UITabBarItem
            let imageSize = CGSizeMake(30, 30)
            
            if let homeSelectedIcon = UIImage(named: "home_full.png") {
                homeTabBarItem.selectedImage = imageWithImage(homeSelectedIcon, scaledToSize: imageSize)
            }
            
            if let homeDefaultIcon = UIImage(named: "home_line.png") {
                homeTabBarItem.image = imageWithImage(homeDefaultIcon, scaledToSize: imageSize)
            }
            
            if let settingsSelectedIcon = UIImage(named: "settings_full.png") {
                settingsTabBarItem.selectedImage = imageWithImage(settingsSelectedIcon, scaledToSize: imageSize)
                
            }
            
            if let settingsDefaultIcon = UIImage(named: "settings_line.png") {
                settingsTabBarItem.image = imageWithImage(settingsDefaultIcon, scaledToSize: imageSize)
                
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
            
            // Add an admin button if need be.
            if currentUser.isAdmin {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    title: "Admin",
                    style: UIBarButtonItemStyle.Plain,
                    target: viewController,
                    action: "adminBarButtonTapped:")
            }
        } else if self.selectedIndex == settingsIndex {
            self.navigationItem.title = "Settings"
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}