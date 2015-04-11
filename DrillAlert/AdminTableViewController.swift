//
//  AdminTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AdminTableViewController: UITableViewController {
    var wells = Array<Well>()
    let adminToWellUsersSegueIdentifier = "AdminToWellUsersSegue"
    
    var currentUser: User!
    
    override func viewDidLoad() {
        //self.wells = Well.getAllWells()
        
        if let navigationController = self.navigationController {
            let yCoord = navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.tableView.frame.width, yCoord))
        }
        
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == adminToWellUsersSegueIdentifier {
            let well = sender as! Well
            let destinationViewController = segue.destinationViewController as! WellUsersTableViewController
            destinationViewController.currentWell = well
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
}

extension AdminTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WellCell") as! UITableViewCell
        let well = wells[indexPath.row]
        
        if let textLabel = cell.textLabel {
            textLabel.text = well.name
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wells.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

extension AdminTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let well = wells[indexPath.row]
        println(well)
        self.performSegueWithIdentifier(adminToWellUsersSegueIdentifier, sender: well)
    }
}