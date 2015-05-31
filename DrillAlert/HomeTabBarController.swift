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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navBarHairlineImageView?.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navBarHairlineImageView?.hidden = false
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
        let selectedColor = UIColor(red: 0.490, green: 0.733, blue: 0.910, alpha: 1.0)
        let deselectedColor = UIColor(red: 0.624, green: 0.627, blue: 0.643, alpha: 1.0)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: deselectedColor], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], forState:.Selected)
        
        
        for item in self.tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(deselectedColor).imageWithRenderingMode(.AlwaysOriginal)
                item.selectedImage = image.imageWithColor(selectedColor).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        super.viewDidLoad()
    }
    
    func changeTitle(newTitle: String) {
        self.title = newTitle
    }
    
    func logoutButtonTapped(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            self.user.logout { (loggedOut) -> Void in
                if loggedOut {
                    if let navigationController = self.navigationController {
                        navigationController.popToRootViewControllerAnimated(true)
                    }
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (alertAction) -> Void in
            
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}