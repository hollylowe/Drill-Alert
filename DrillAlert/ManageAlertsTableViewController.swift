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
    var currentUser: User!
    
    override func viewDidLoad() {
        self.title = "Manage Alerts"
        /*
        alerts = Alert.getAlertsForUser(wellboreDetailViewController.currentUser, andWellbore: wellboreDetailViewController.currentWellbore)
        */
        
        // Retrieve all the alerts that the user has 
        // saved on their device.
        alerts = Alert.fetchAllInstances()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: "rightBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: "leftBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    func updateView() {
        alerts = Alert.fetchAllInstances()
        self.tableView.reloadData()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ManageAlertsTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let addEditAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.getStoryboardIdentifier()) as AddEditAlertNavigationController
        let addEditAlertViewController = addEditAlertNavigationController.viewControllers[0] as AddEditAlertTableViewController
        addEditAlertViewController.delegate = self
        addEditAlertViewController.currentUser = self.currentUser
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
                addEditAlertTableViewController.delegate = self
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