//
//  SettingsTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/26/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    
    var currentUser: User!
    
    @IBOutlet weak var loggedInAsCell: UITableViewCell!
    @IBAction func logOutButtonTapped(sender: AnyObject) {
        if currentUser.isSDIAuthenticatedUser {
            // TODO: Use SDI auth to log them out, delete the session
        }
        
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        // Sets the tableview y coordinate to the toolbarheight
        if let navigationController = self.navigationController {
            let yCoord = navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            let headerViewRect = CGRectMake(0, 0, self.tableView.frame.width, yCoord + 20)
            self.tableView.tableHeaderView = UIView(frame: headerViewRect)
        }
        
        if let detailTextLabel = loggedInAsCell.detailTextLabel {
            detailTextLabel.text = currentUser.fullName
        }
        
        super.viewDidLoad()
    }
}