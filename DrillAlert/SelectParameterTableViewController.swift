//
//  SelectParameterTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 12/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SelectParameterTableViewController: UITableViewController {
    let parameterCellIdentifier = "ParameterCell"
    let numberOfSections = 1
    let parameterSection = 0
    var delegate: AddParameterAlertTableViewController!
    var parameters = Array<Parameter>()
    
    override func viewDidLoad() {
        self.title = "Select Parameter"
        parameters = Parameter.getAllParameters()
        super.viewDidLoad()
    }
}

extension SelectParameterTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row = 0
        // Clear all the checkmarks
        for parameter in parameters {
            let indexPath = NSIndexPath(forRow: row, inSection: parameterSection)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
            row = row + 1
        }
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            // If the cell is checked, deselect it
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                delegate.selectedParameter = nil
            } else if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                delegate.selectedParameter = parameters[indexPath.row]
            }
        }
        
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        }
    }
}

extension SelectParameterTableViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if section == parameterSection {
            numberOfRows = parameters.count
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(parameterCellIdentifier) as UITableViewCell
        
        if let textLabel = cell.textLabel {
            let parameter = parameters[indexPath.row]
            textLabel.text = parameter.name
            
            if let selectedParameter = delegate.selectedParameter {
                if selectedParameter.name == parameter.name {
                    cell.accessoryType = .Checkmark
                }
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result: String?
        
        if section == parameterSection {
            result = "Parameters"
        }
        
        return result
    }
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
}