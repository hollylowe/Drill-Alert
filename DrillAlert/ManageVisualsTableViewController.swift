//
//  ManageVisualsTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

//TODO populate this view with a custom table cell that is a name of a visual and switch that indicates if it will show up on the home screen or not. 

class ManageVisualsNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String! {
        return "ManageVisualsNavigationController"
    }
}

class ManageVisualsTableViewController: UITableViewController {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    
    
    override func viewDidLoad() {
        self.title = "Manage Visuals"
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "rightBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "leftBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ParameterAlertsTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        //TODO: this should change the items from switches to three lines and delete icons
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "AddButtonItemTapped:")
    }
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        //TODO: save all currently set states? this might be controlled elsewhere
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func AddButtonItemTapped(sender: UIBarButtonItem) {
        print ("add a new visual")
        //TODO: Add functionality
    }
    
    
}

