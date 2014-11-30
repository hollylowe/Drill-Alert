//
//  ParameterAlertsTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/30/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ParameterAlertsTableViewController: UITableViewController {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var parameterAlerts: [ParameterAlert]!
    
    override func viewDidLoad() {
        parameterAlerts = ParameterAlert.getParameterAlertsForUser(wellboreDetailViewController.currentUser, andWellbore: wellboreDetailViewController.currentWellbore)
        
        super.viewDidLoad()
    }
}

extension ParameterAlertsTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ParameterAlertTableViewCell.getCellIdentifier()) as ParameterAlertTableViewCell
        let parameterAlert = parameterAlerts[indexPath.row]
        
        cell.setupWithParameterAlert(parameterAlert)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameterAlerts.count
    }
}