//
//  AddParameterAlertTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/30/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddParameterAlertNavigationController: UINavigationController {
    class func getStoryboardIdentifier() -> String! {
        return "AddParameterAlertNavigationController"
    }
}

class AddParameterAlertTableViewController: UITableViewController {
    
    // Segues
    let selectParameterSegue = "SelectParameterSegue"
    let addOrEditAlertSegue = "AddOrEditAlertSegue"
    
    var alerts = Array<Alert>()
    var selectedParameter: Parameter?
    var delegate: ParameterAlertsTableViewController!
    
    let numberOfSections = 2
    let parameterSection = 0
    let alertsSection = 1
    
    class func getStoryboardIdentifier() -> String! {
        return "AddParameterAlertTableViewController"
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        // TODO: remove this stuff and fake notification, purely for the demo
        if let parameter = selectedParameter {
            let parameterAlert = ParameterAlert(parameter: parameter, alerts: alerts)
            // delegate.addAlertToTableView(parameterAlert)
            
            let alert = alerts[0]
            var noti = UILocalNotification()
            var body = parameter.name
            noti.fireDate = NSDate(timeInterval: 6, sinceDate: NSDate())
            
            if alert.alertWhenRisesToValue {
                body = body + " on Wellbore 1 has reached \(alert.value)."
            } else {
                body = body + " on Wellbore 1 has fallen to \(alert.value)."
            }
            
            noti.alertBody = body
            noti.timeZone = NSTimeZone.defaultTimeZone()
            UIApplication.sharedApplication().scheduleLocalNotification(noti)
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == selectParameterSegue {
            let destinationViewController = segue.destinationViewController as SelectParameterTableViewController
            destinationViewController.delegate = self
        } else if segue.identifier == addOrEditAlertSegue {
            let destinationViewController = segue.destinationViewController as UINavigationController
            let addOrEditAlertViewController = destinationViewController.viewControllers[0] as AddOrEditAlertTableViewController
            if sender == nil {
                // Add alert view should be pushed
                addOrEditAlertViewController.delegate = self
                addOrEditAlertViewController.alertToEdit = nil
            } else {
                let alert = sender as Alert
                addOrEditAlertViewController.delegate = self
                addOrEditAlertViewController.alertToEdit = alert
            }
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func pushSelectParameterView() {
        self.performSegueWithIdentifier(selectParameterSegue, sender: self)
    }
    
    func pushAddAlertView() {
        self.performSegueWithIdentifier(addOrEditAlertSegue, sender: nil)
    }
    
    func pushEditAlertViewWithAlert(alert: Alert) {
        self.performSegueWithIdentifier(addOrEditAlertSegue, sender: alert)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
}

extension AddParameterAlertTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case parameterSection:
            // Parameter cell selected, push select parameter view
            pushSelectParameterView()
        case alertsSection:
            // Alert cell selected, push edit alert view
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.reuseIdentifier == "NewAlertCell" {
                    pushAddAlertView()
                } else {
                    let alert = alerts[indexPath.row]
                    pushEditAlertViewWithAlert(alert)
                }
            }
            
            
        default: println("Unknown section selected.")
        }
    }
    
}
extension AddParameterAlertTableViewController: UITableViewDataSource {
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
            
        case parameterSection:
            cell = tableView.dequeueReusableCellWithIdentifier("ParameterCell") as UITableViewCell
            if let textLabel = cell.textLabel {
                textLabel.text = "Parameter"
            }
            if let detailTextLabel = cell.detailTextLabel {
                if let parameter = selectedParameter {
                    detailTextLabel.text = parameter.name
                } else {
                    detailTextLabel.text = "None"
                }
            }
            
        case alertsSection:
            // If it is not the last cell
            let alertSectionRow = indexPath.row
            if alerts.count != 0 && alertSectionRow < alerts.count {
                let alert = alerts[alertSectionRow]
                
                cell = tableView.dequeueReusableCellWithIdentifier("AlertCell") as UITableViewCell
                if alert.alertWhenRisesToValue {
                    if let textLabel = cell.textLabel {
                        textLabel.text = "Rise to \(alert.value), \(alert.priority.rawValue) Priority"
                    }
                } else {
                    if let textLabel = cell.textLabel {
                        textLabel.text = "Falls to \(alert.value), \(alert.priority.rawValue) Priority"
                    }
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("NewAlertCell") as UITableViewCell
                if let textLabel = cell.textLabel {
                    textLabel.text = "New..."
                }
            }
        default:
            println("Unknown section in tableview.")
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result: Int!
        
        switch section {
        case parameterSection:
            result = 1
        case alertsSection:
            result = 1 + alerts.count
        default:
            result = 0
        }
        
        return result
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
}