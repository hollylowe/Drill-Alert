//
//  HomeTabBarController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/26/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

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
        self.user.logout { (loggedOut) -> Void in
            if loggedOut {
                if let navigationController = self.navigationController {
                    navigationController.popToRootViewControllerAnimated(true)
                }
            }
        }
    }
    
    
}