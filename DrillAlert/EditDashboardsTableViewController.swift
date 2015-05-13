//
//  EditLayoutsTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class EditDashboardsTableViewController: LoadingTableViewController {
    var user: User!
    var wellbore: Wellbore!
    var dashboards = Array<Dashboard>()
    
    override func viewDidLoad() {
        self.dataSource = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddEditDashboardTableViewController.editDashboardSegueIdentifier() {
            if let cell = sender as? UITableViewCell {
                if let indexPath = self.tableView.indexPathForCell(cell) {
                    let destinationNavigationController = segue.destinationViewController as! AddEditDashboardNavigationController
                    let destination = destinationNavigationController.viewControllers[0] as! AddEditDashboardTableViewController
                    
                    destination.dashboardToEdit = self.dashboards[indexPath.row]
                    destination.user = self.user
                    destination.wellbore = self.wellbore
                }
            }
            
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EditDashboardTableViewCell.cellIdentifier()) as! EditDashboardTableViewCell
        let dashboard = self.dashboards[indexPath.row]
        cell.setupWithDashboard(dashboard)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dashboards.count
    }
    
    class func entrySegueIdentifier() -> String! {
        return "EditDashboardsSegueIdentifier"
    }
    
}

extension EditDashboardsTableViewController: LoadingTableViewControllerDataSource {
    func dataLoadOperation() {
        let (newDashboards, error) = Dashboard.getDashboardsForUser(self.user, andWellbore: self.wellbore)
        
        if error == nil {
            self.dashboards = newDashboards
        } else {
            // TODO: Show user error
            self.loadError = true
            println(error)
        }
    }
    
    func shouldShowNoDataMessage() -> Bool {
        return self.dashboards.count == 0
    }
    
    func noDataMessage() -> String {
        return "No Dashboards"
    }
}
