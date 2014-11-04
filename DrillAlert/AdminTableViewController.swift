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
    
    override func viewDidLoad() {
        self.wells = Well.getAllWells()
        super.viewDidLoad()
    }
}

extension AdminTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WellCell") as UITableViewCell
        let well = wells[indexPath.row]
        
        cell.textLabel.text = well.name
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