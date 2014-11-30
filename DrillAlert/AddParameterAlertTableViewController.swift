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
    
    var alerts = Array<Alert>()
    var selectedParameter: Parameter?
    
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddParameterAlertTableViewController: UITableViewDataSource {
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
            
        case parameterSection:
            cell = tableView.dequeueReusableCellWithIdentifier("ParameterCell") as UITableViewCell
            cell.textLabel.text = "Parameter"
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
                    cell.textLabel.text = "Rise to \(alert.value), \(alert.priority) Priority"

                } else {
                    cell.textLabel.text = "Falls to \(alert.value), \(alert.priority) Priority"
                    
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("NewAlertCell") as UITableViewCell
                cell.textLabel.text = "New..."
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