//
//  AlertsInboxTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 1/19/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertInboxTableViewController: UITableViewController {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    
    let numberOfSections = 4
    let criticalSection = 0
    let warningSection = 1
    let informationSection = 2
    let readSection = 3
    
    class func storyboardIdentifier() -> String! {
        return "AlertInboxTableViewController"
    }
    
    func getCriticalAlertAtIndex(index: Int) -> Alert! {
        return Alert(title: "Critical", information: "Critical Alert")
    }
    
    func getWarningAlertAtIndex(index: Int) -> Alert! {
        return Alert(title: "Warning", information: "Warning Alert")

    }
    
    func getInformationAlertAtIndex(index: Int) -> Alert! {
        return Alert(title: "Information", information: "Information Alert")

    }
    
    func getReadAlertAtIndex(index: Int) -> Alert! {
        return Alert(title: "Read", information: "Read Alert")

    }
    
}

extension AlertInboxTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                AlertInboxCell.cellIdentifier()) as AlertInboxCell
            var alert: Alert!
            
            switch indexPath.section {
            case criticalSection:
                alert = getCriticalAlertAtIndex(indexPath.row)
            case warningSection:
                alert = getWarningAlertAtIndex(indexPath.row)
            case informationSection:
                alert = getInformationAlertAtIndex(indexPath.row)
            case readSection:
                alert = getReadAlertAtIndex(indexPath.row)
            default:
                alert = Alert(title: "invalid", information: "invalid")
            }
            
            cell.setupWithAlert(alert)
            
            return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            var numberOfRows = 0
            
            switch section {
            case criticalSection:
                numberOfRows = 1
            case warningSection:
                numberOfRows = 2
            case informationSection:
                numberOfRows = 1
            case readSection:
                numberOfRows = 1
            default:
                numberOfRows = 0
            }
            
            return numberOfRows
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            var title = "NA"
            
            switch section {
            case criticalSection:
                title = "Critical"
            case warningSection:
                title = "Warning"
            case informationSection:
                title = "Information"
            case readSection:
                title = "Read"
            default:
                title = "None"
            }
            
            return title
    }
}

extension AlertInboxTableViewController: UITableViewDelegate {
    
}
