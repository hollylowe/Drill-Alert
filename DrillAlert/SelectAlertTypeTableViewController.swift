//
//  SelectParameterTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 12/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SelectAlertTypeTableViewController: UITableViewController {
    let alertTypeCellIdentifier = "AlertTypeCell"
    let numberOfSections = 1
    let alertTypeSection = 0
    var delegate: AddEditAlertTableViewController!
    
    class func getEntrySegueIdentifier() -> String {
        return "SelectAlertTypeSegue"
    }
    
    override func viewDidLoad() {
        self.title = "Select Alert Type"
        super.viewDidLoad()
    }
}

extension SelectAlertTypeTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row = 0
        // Clear all the checkmarks
        for alertType in AlertType.allValues {
            let indexPath = NSIndexPath(forRow: row, inSection: alertTypeSection)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
            row = row + 1
        }
        
        // Select the alert type
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            // If the cell is checked, deselect it
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            cell.accessoryType = .Checkmark
            let selectedAlertType = AlertType.allValues[indexPath.row]
            
            delegate.selectedAlertType = selectedAlertType
            delegate.setAlertTypeLabelTextWithAlertType(selectedAlertType)
        }
        
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
    }
}

extension SelectAlertTypeTableViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if section == alertTypeSection {
            numberOfRows = AlertType.allValues.count
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(alertTypeCellIdentifier) as UITableViewCell
        
        if let textLabel = cell.textLabel {
            let alertType = AlertType.allValues[indexPath.row]
            textLabel.text = alertType.name
            
            if let selectedAlertType = delegate.selectedAlertType {
                if selectedAlertType == alertType {
                    cell.accessoryType = .Checkmark
                }
            }
            
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result: String?
        
        if section == alertTypeSection {
            result = "Alert Types"
        }
        
        return result
    }
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
}