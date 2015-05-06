//
//  ParameterAlertsTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/30/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ManageAlertsTableViewController: LoadingTableViewController, LoadingTableViewControllerDataSource {
    // Implicit, set by the previous view controller
    var user: User!
    var alerts = Array<Alert>()
    var wellbore: Wellbore!
    
    class func storyboardIdentifier() -> String! {
        return "ManageAlertsTableViewController"
    }
    
    override func viewDidLoad() {
        self.title = "Manage Alerts"
        self.dataSource = self
        self.noDataLabelOffset = 39.0
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor(
            red: 0.937,
            green: 0.937,
            blue: 0.937,
            alpha: 1.0)
        
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
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let destinationNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.storyboardIdentifier()) as! AddEditAlertNavigationController
        let destination = destinationNavigationController.viewControllers[0] as! AddEditAlertTableViewController
        destination.delegate = self
        destination.wellbore = self.wellbore
        destination.currentUser = self.user

        self.presentViewController(destinationNavigationController, animated: true, completion: nil)
    }
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If we are going to the Add Edit Alert page with a segue,
        // then we are editing an alert.
        if segue.identifier == AddEditAlertNavigationController.entrySegueIdentifier() {
            if let alert = sender as? Alert {
                // Set the alert to edit in the following view controller
                let destinationNavigationController = segue.destinationViewController as! AddEditAlertNavigationController
                let destination = destinationNavigationController.viewControllers[0] as! AddEditAlertTableViewController
                destination.alertToEdit = alert
                destination.delegate = self
                destination.currentUser = self.user
                destination.wellbore = self.wellbore
            }
            
        }
    }
}

extension ManageAlertsTableViewController: LoadingTableViewControllerDataSource {
    func dataLoadOperation() {
        var (resultAlerts, resultError) = Alert.getAlertsForUser(
            self.user,
            andWellbore: self.wellbore)
        
        self.alerts = resultAlerts
    }
    
    func shouldShowNoDataMessage() -> Bool {
        return self.alerts.count == 0
    }
    
    func noDataMessage() -> String {
        return "No Alerts"
    }
}

extension ManageAlertsTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AlertTableViewCell.cellIdentifier()) as! AlertTableViewCell
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
        self.performSegueWithIdentifier(AddEditAlertNavigationController.entrySegueIdentifier(), sender: alert)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let alert = alerts[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(AddEditAlertNavigationController.entrySegueIdentifier(), sender: alert)
    }
}