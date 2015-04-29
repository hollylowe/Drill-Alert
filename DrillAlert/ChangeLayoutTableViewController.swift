//
//  ChangeLayoutTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ChangeLayoutTableViewController: UITableViewController {
    var user: User!
    var wellbore: Wellbore!
    var selectedLayout: Layout?
    var manageLayoutsTableViewController: ManageLayoutsTableViewController!
    var layouts = Array<Layout>()

    override func viewDidLoad() {
        let (newLayouts, error) = Layout.getLayoutsForUser(self.user, andWellbore: self.wellbore)
        
        if error == nil {
            self.layouts = newLayouts
        } else {
            // TODO: Show user error
            println(error)
        }
        
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LayoutTableViewCell.cellIdentifier()) as! LayoutTableViewCell
        let layout = self.layouts[indexPath.row]
        cell.setupWithLayout(layout)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.layouts.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let layout = self.layouts[indexPath.row]
        self.manageLayoutsTableViewController.wellboreDetailViewController.layoutViewController.updateCurrentLayout(layout)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func entrySegueIdentifier() -> String! {
        return "ChangeLayoutSegueIdentifier"
    }
    
}