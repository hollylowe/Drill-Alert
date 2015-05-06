//
//  ChangeLayoutTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ChangeDashboardTableViewController: LoadingTableViewController {
    var user: User!
    var wellbore: Wellbore!
    var manageDashboardsTableViewController: ManageDashboardsTableViewController!

    var selectedDashboard: Dashboard?
    var dashboards = Array<Dashboard>()
    
    override func viewDidLoad() {
        self.dataSource = self
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(DashboardTableViewCell.cellIdentifier()) as! DashboardTableViewCell
        let dashboard = self.dashboards[indexPath.row]
        cell.setupWithDashboard(dashboard)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dashboards.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dashboard = self.dashboards[indexPath.row]
        self.manageDashboardsTableViewController.wellboreDetailViewController.dashboardViewController.updateCurrentDashboard(dashboard)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func entrySegueIdentifier() -> String! {
        return "ChangeDashboardSegueIdentifier"
    }
    
}

extension ChangeDashboardTableViewController: LoadingTableViewControllerDataSource {
    func shouldShowNoDataMessage() -> Bool {
        return self.dashboards.count == 0
    }
    
    func noDataMessage() -> String {
        return "No Dashboards"
    }
    
    func dataLoadOperation() {
        println("data load")
        println("Wellbore: \(self.wellbore)")
        println("User: \(self.user)")
        
        let (newDashboards, error) = Dashboard.getDashboardsForUser(self.user, andWellbore: self.wellbore)
        println("done")
        if error == nil {
            self.dashboards = newDashboards
        } else {
            // TODO: Show user error
            println(error)
        }
    }
}