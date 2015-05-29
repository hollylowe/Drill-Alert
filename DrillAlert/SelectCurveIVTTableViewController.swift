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
    var addEditAlertDelegate: AddEditAlertTableViewController?
    var addEditTrackDelegate: AddEditTrackTableViewController?
    var addEditCanvasItemDelegate: AddEditCanvasItemTableViewController?
    
    var user: User!
    var wellbore: Wellbore!
    var curveToEdit: Curve?
    
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
                destination.wellbore = self.wellbore
                destination.curveToEdit = self.curveToEdit
                destination.user = self.user
                if let delegate = self.addEditAlertDelegate {
                    destination.addEditAlertDelegate = delegate
                }
                
                if let delegate = self.addEditCanvasItemDelegate {
                    destination.addEditCanvasItemDelegate = delegate
                }
                
                if let delegate = self.addEditTrackDelegate {
                    destination.addEditTrackDelegate = delegate
                }
                
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