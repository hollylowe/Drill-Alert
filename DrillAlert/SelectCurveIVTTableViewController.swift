//
//  SelectCurveIVTTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SelectCurveIVTTableViewController: UITableViewController {
    var delegate: AddEditAlertTableViewController!
    class func entrySegueIdentifier() -> String {
        return "SelectCurveIVTSegue"
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Curve IVT"
    }
    override func viewDidLoad() {
        self.title = "Select IVT"
        self.tableView.separatorColor = UIColor.blackColor()
        self.tableView.tableFooterView = UIView()
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54.0
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectCurveTableViewController.entrySegueIdentifier() {
            if let indexPath = sender as? NSIndexPath {
                let curveIVT = CurveIVT.allValues[indexPath.row]
                let destination = segue.destinationViewController as! SelectCurveTableViewController
                destination.curveIVT = curveIVT
                destination.wellbore = self.delegate.wellbore
                destination.user = self.delegate.currentUser
                destination.delegate = self.delegate
            }
        }
        super.prepareForSegue(segue, sender: sender)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(SelectCurveTableViewController.entrySegueIdentifier(), sender: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let curveIVT = CurveIVT.allValues[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(LabelDisclosureCell.cellIdentifier()) as! LabelDisclosureCell
        if let label = cell.textLabel {
            label.text = curveIVT.toString()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurveIVT.allValues.count
    }
}