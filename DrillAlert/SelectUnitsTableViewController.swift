//
//  UnitsTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SelectUnitsTableViewController: UITableViewController {
    var delegate: AddEditPlotTableViewController!

    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    let unitsSection = 0
    let numberOfSections = 1
    
    //
    //  -----------------------
    // |    Class Functions    |
    //  -----------------------
    //
    class func storyboardIdentifier() -> String! {
        return "SelectUnitsTableViewController"
    }
    
    class func entrySegueIdentifier() -> String! {
        return "SelectUnitsTableViewControllerSegue"
    }
    
    func resetAccessoryTypes() {
        let rowCount = PlotUnits.allValues.count
        for row in 0...rowCount {
            let indexPath = NSIndexPath(forRow: row, inSection: self.unitsSection)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
    }
}

extension SelectUnitsTableViewController: UITableViewDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Units"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if section == self.unitsSection {
            numberOfRows = PlotUnits.allValues.count
        }

        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PlotUnitsCell.cellIdentifier()) as! PlotUnitsCell

        let units = PlotUnits.allValues[indexPath.row]
        cell.setupWithUnits(units)
        
        if let selectedUnits = self.delegate.selectedUnits {
            if selectedUnits == units {
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == self.unitsSection {
            // Add a check mark and pop to the last
            // view controller, after setting the
            // selected units
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                self.resetAccessoryTypes()
                cell.accessoryType = .Checkmark
            }
            
            let type = PlotUnits.allValues[indexPath.row]
            self.delegate.selectedUnits = type
            if let navigationController = self.navigationController {
                navigationController.popViewControllerAnimated(true)
            }
        }
    }
}