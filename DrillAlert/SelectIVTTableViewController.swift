//
//  ChooseIVTTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SelectIVTTableViewController: UITableViewController {
    var delegate: AddEditPlotTableViewController!
    
    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    let independentVariableTypeSection = 0
    let numberOfSections = 1
    
    //
    //  -----------------------
    // |    Class Functions    |
    //  -----------------------
    //
    class func storyboardIdentifier() -> String! {
        return "SelectIVTTableViewController"
    }
    
    class func entrySegueIdentifier() -> String! {
        return "SelectIVTTableViewControllerSegue"
    }
    
    func resetAccessoryTypes() {
        let rowCount = PlotIndependentVariableType.allValues.count
        for row in 0...rowCount {
            let indexPath = NSIndexPath(forRow: row, inSection: self.independentVariableTypeSection)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
    }
}

extension SelectIVTTableViewController: UITableViewDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Independent Variable Type"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if section == self.independentVariableTypeSection {
            numberOfRows = PlotIndependentVariableType.allValues.count
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PlotIndependentVariableTypeCell.cellIdentifier()) as! PlotIndependentVariableTypeCell
        let type = PlotIndependentVariableType.allValues[indexPath.row]
        cell.setupWithType(type)
        /*
        if let selectedIVT = self.delegate.selectedIVT {
            if selectedIVT == type {
                cell.accessoryType = .Checkmark
            }
        }
        */
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == self.independentVariableTypeSection {
            // Add a check mark and pop to the last
            // view controller, after setting the 
            // selected IVT 
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                self.resetAccessoryTypes()
                cell.accessoryType = .Checkmark
            }
            
            let type = PlotIndependentVariableType.allValues[indexPath.row]
            // self.delegate.selectedIVT = type
            if let navigationController = self.navigationController {
                navigationController.popViewControllerAnimated(true)
            }
        }
    }
}