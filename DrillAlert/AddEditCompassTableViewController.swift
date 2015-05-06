//
//  AddEditCompassTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditCompassTableViewController: UITableViewController {
    let numberOfSections = 3
    let compassNameSection = 0
    let sensorTypeSection = 1
    let dataSourceSection = 2
    
    var compassToEdit: Page?
    
    override func viewDidLoad() {
        if let compass = self.compassToEdit {
            self.title = "Edit Compass"
        } else {
            self.title = "Add Compass"
        }
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String {
        return "AddEditCompassTableViewController"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.compassNameSection: cell = tableView.dequeueReusableCellWithIdentifier(CompassNameInputTableViewCell.cellIdentifier()) as! CompassNameInputTableViewCell
        case self.sensorTypeSection:
            let sensorTypeCell = tableView.dequeueReusableCellWithIdentifier(CompassSensorTypeCell.cellIdentifier()) as! CompassSensorTypeCell
            let sensorType = CompassSensorType.allValues[indexPath.row]
            sensorTypeCell.setupWithSensorType(sensorType)
            cell = sensorTypeCell
        case self.dataSourceSection:
            let dataSourceCell = tableView.dequeueReusableCellWithIdentifier(CompassDataSourceCell.cellIdentifier()) as! CompassDataSourceCell
            let dataSource = CompassDataSource.allValues[indexPath.row]
            dataSourceCell.setupWithDataSource(dataSource)
            cell = dataSourceCell
        default: break
        }
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.compassNameSection: numberOfRows = 1
        case self.sensorTypeSection: numberOfRows = CompassSensorType.allValues.count
        case self.dataSourceSection: numberOfRows = CompassDataSource.allValues.count
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section {
        case self.compassNameSection: title = ""
        case self.sensorTypeSection: title = "Sensor Type"
        case self.dataSourceSection: title = "Data Source"
        default: title = ""
        }
        
        return title
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
}