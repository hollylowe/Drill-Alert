//
//  ParameterAlertsTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/30/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ParameterAlertsNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String! {
        return "ParameterAlertsNavigationController"
    }
}

class ParameterAlertsTableViewController: UITableViewController {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var parameterAlerts: [ParameterAlert]!
    
    override func viewDidLoad() {
        self.title = "Manage Alerts"
        parameterAlerts = ParameterAlert.getParameterAlertsForUser(wellboreDetailViewController.currentUser, andWellbore: wellboreDetailViewController.currentWellbore)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "leftBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ParameterAlertsTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let addAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddParameterAlertNavigationController.getStoryboardIdentifier()) as AddParameterAlertNavigationController
        let addParameterAlertViewController = addAlertNavigationController.viewControllers[0] as AddParameterAlertTableViewController
        addParameterAlertViewController.delegate = self
        self.presentViewController(addAlertNavigationController, animated: true, completion: nil)
    }
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension ParameterAlertsTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ParameterAlertTableViewCell.getCellIdentifier()) as ParameterAlertTableViewCell
        let parameterAlert = parameterAlerts[indexPath.row]
        
        cell.setupWithParameterAlert(parameterAlert)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameterAlerts.count
    }
}