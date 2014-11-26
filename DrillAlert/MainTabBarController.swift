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
            
        }
        
        super.viewDidLoad()
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