//
//  WellUsersTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/9/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class WellUsersTableViewController: UITableViewController {
    // Implicit - set by the previous Admin view controller 
    var currentWell: Well!
    let userCellIdentifier = "UserCell"
    
    var users = Array<User>()
    
    override func viewDidLoad() {
        self.title = currentWell.name + " Users"
        super.viewDidLoad()
    }
}

extension WellUsersTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(userCellIdentifier) as! UITableViewCell
        let user = users[indexPath.row]
        
        if let textLabel = cell.textLabel {
            // textLabel.text = user.fullName
        }
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}