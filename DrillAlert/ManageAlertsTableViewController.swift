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
    var alerts = Array<Alert>()
    var currentUser: User!
    var wellbore: Wellbore! 
    
    var shouldLoadFromNetwork = true
    var loadingIndicator: UIActivityIndicatorView?
    var loadingData = true
    var loadError = false
    
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.loadData()
        
        self.title = "Manage Alerts"
        
        
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
    
    func refresh(sender:AnyObject)
    {
        self.reloadAlerts()
        self.refreshControl!.endRefreshing()
        self.tableView.reloadData()
    }
    
    func reloadAlerts() {
        var (resultAlerts, resultError) = Alert.getAlertsForUser(self.currentUser, andWellbore: self.wellboreDetailViewController.currentWellbore)
        
        self.alerts = resultAlerts
    }
    
    func loadData() {
        loadError = false
        loadingData = false
        
        if shouldLoadFromNetwork {
            loadError = false
            loadingData = true
            self.tableView.reloadData()
            
            // TODO: This will need to change if we add a way to refresh this page, which we probably will.
            // Instead, we could use the NSURLConnection asynchrounous call. This is because users could
            // refresh the page faster than this call could load it, resulting in multiple threads doing
            // the same operation and messing up the table view.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.reloadAlerts()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadingData = false
                    self.tableView.reloadData()
                })
            })
            
        } else {
            self.tableView.reloadData()
        }
    }
    
    func updateView() {
        self.reloadAlerts()
        self.tableView.reloadData()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ManageAlertsTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let addEditAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.getStoryboardIdentifier()) as! AddEditAlertNavigationController
        let addEditAlertViewController = addEditAlertNavigationController.viewControllers[0] as! AddEditAlertTableViewController
        addEditAlertViewController.delegate = self
        addEditAlertViewController.currentUser = self.currentUser
        addEditAlertViewController.wellbore = self.wellbore

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
                let destination = segue.destinationViewController as! AddEditAlertNavigationController
                let addEditAlertTableViewController = destination.viewControllers[0] as! AddEditAlertTableViewController
                addEditAlertTableViewController.alertToEdit = alert
                addEditAlertTableViewController.delegate = self
                addEditAlertTableViewController.currentUser = self.currentUser
                addEditAlertTableViewController.wellbore = self.wellbore
            }
            
        }
    }
}

extension ManageAlertsTableViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 1
        
        if loadingData {
            numberOfSections = 0
            let indicatorWidth: CGFloat = 20
            let indicatorHeight: CGFloat = 20
            // Display loading indicator
            var backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake((self.view.bounds.size.width - indicatorWidth) / 2, (self.view.bounds.size.height - indicatorHeight) / 2, indicatorWidth, indicatorHeight))
            
            loadingIndicator.color = UIColor.grayColor()
            loadingIndicator.startAnimating()
            backgroundView.addSubview(loadingIndicator)
            self.tableView.backgroundView = backgroundView
            self.tableView.separatorStyle = .None
            
        } else if self.alerts.count == 0 {
                // Show no alerts message
                numberOfSections = 0
                
                let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                var noAlertNotificationsLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 39.0))
                noAlertNotificationsLabel.text = "No Alerts"
                noAlertNotificationsLabel.textColor = textColor
                noAlertNotificationsLabel.numberOfLines = 0
                noAlertNotificationsLabel.textAlignment = .Center
                noAlertNotificationsLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
                noAlertNotificationsLabel.sizeToFit()
                
                self.tableView.backgroundView = noAlertNotificationsLabel
                self.tableView.separatorStyle = .None
                
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .SingleLine
        }
        
        return numberOfSections
    }
    
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
        self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: alert)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let alert = alerts[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: alert)
    }
}