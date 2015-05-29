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
    var wellboreDetailViewController: WellboreDetailViewController!
    var user: User!
    var alerts = Array<Alert>()
    var curves = Array<Curve>()
    var wellbore: Wellbore!
    
    class func storyboardIdentifier() -> String! {
        return "ManageAlertsTableViewController"
    }
    
    override func viewDidLoad() {
        self.title = "Manage Alerts"
        self.dataSource = self
        self.noDataLabelOffset = 39.0
        self.tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.noDataLabelOffset))
        self.tableView.backgroundColor = UIColor.blackColor()
        
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
}

extension ManageAlertsTableViewController: LoadingTableViewControllerDataSource {
    func dataLoadOperation() {
        var (resultAlerts, resultError) = Alert.getAlertsForUser(
            self.user,
            andWellbore: self.wellbore)
        // TODO: Move this to the Wellbore detail view controller
        var (resultCurves, resultAlertsError) = self.wellbore.getCurves(self.user)
        
        self.alerts = resultAlerts
        self.curves = resultCurves
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
        
        // TODO: Use faster filter method
        for curve in self.curves {
            if curve.id == alert.curveID {
                cell.setupWithAlert(alert, andCurve: curve)
                break
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func showEditAlertVCForAlert(alert: Alert) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.storyboardIdentifier()) as! AddEditAlertNavigationController
        let destination = destinationNavigationController.viewControllers[0] as! AddEditAlertTableViewController
        destination.delegate = self
        destination.alertToEdit = alert
        
        // TODO: Use faster filter method
        for curve in self.curves {
            if curve.id == alert.curveID {
                destination.selectedCurve = curve
                break
            }
        }
        
        destination.wellbore = self.wellbore
        destination.currentUser = self.user
        
        self.wellboreDetailViewController.presentViewController(destinationNavigationController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alert = alerts[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.showEditAlertVCForAlert(alert)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let alert = alerts[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.showEditAlertVCForAlert(alert)
    }
}