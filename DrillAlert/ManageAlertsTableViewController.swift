//
//  ParameterAlertsTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/30/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ManageAlertsNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String! {
        return "ManageAlertsNavigationController"
    }
}

class ManageAlertsTableViewController: UITableViewController {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var alerts: [Alert]!
    
    override func viewDidLoad() {
        self.title = "Manage Alerts"
        alerts = Alert.getAlertsForUser(wellboreDetailViewController.currentUser, andWellbore: wellboreDetailViewController.currentWellbore)
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "leftBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ManageAlertsTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let addEditAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.getStoryboardIdentifier()) as AddEditAlertNavigationController
        let addEditAlertViewController = addEditAlertNavigationController.viewControllers[0] as AddEditAlertTableViewController
        addEditAlertViewController.delegate = self
        self.presentViewController(addEditAlertNavigationController, animated: true, completion: nil)
        
    }
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If we are going to the Add Edit Alert page with a segue,
        // then we are editing an alert. 
        
        if segue.identifier == AddEditAlertNavigationController.getEntrySegueIdentifier() {
            if let alert = sender as? Alert {
                // Set the alert to edit in the following view controller
                let destination = segue.destinationViewController as AddEditAlertNavigationController
                let addEditAlertTableViewController = destination.viewControllers[0] as AddEditAlertTableViewController
                addEditAlertTableViewController.alertToEdit = alert
            }
            
        }
    }
}

extension ManageAlertsTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AlertTableViewCell.cellIdentifier()) as AlertTableViewCell
        let alert = alerts[indexPath.row]
        
        cell.setupWithAlert(alert)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = alerts[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: alert)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let alert = alerts[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: alert)
    }
}