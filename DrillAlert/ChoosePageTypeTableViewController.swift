//
//  ChoosePanelTypeTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ChoosePageTypeTableViewController: UITableViewController {
    var user: User!
    var wellbore: Wellbore!
    var delegate: AddEditDashboardTableViewController!
    
    let newPlotSection = 0
    let newCanvasSection = 1
    // let newCompassSection = 2
    let newFromExistingSection = 2
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorStyle = .None
        // self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50.0))
        super.viewDidLoad()
    }
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = view as? UITableViewHeaderFooterView {
            footer.textLabel.textColor = UIColor(red: 0.624, green: 0.627, blue: 0.643, alpha: 1.0)
            
        }
    }
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel.textColor = UIColor(red: 0.624, green: 0.627, blue: 0.643, alpha: 1.0)
        }
    }
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func storyboardIdentifier() -> String! {
        return "ChoosePageTypeTableViewController"
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = ""
        
        if section == self.newPlotSection {
            footer = "Plot data vs. depth or time."
        } else if section == self.newCanvasSection {
            footer = "Show a combination of number readouts and gauges."
        }
        /*
        else if section == self.newCompassSection {
            footer = "Create a compass from a toolface and data source."
        }
        */
        return footer
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddEditPlotTableViewController.addPlotEntrySegueIdentifier() {
            let destination = segue.destinationViewController as! AddEditPlotTableViewController
            destination.delegate = self.delegate
            destination.wellbore = self.wellbore
            destination.user = self.user
        } else if segue.identifier == AddEditCanvasTableViewController.addCanvasEntrySegueIdentifier() {
            let destination = segue.destinationViewController as! AddEditCanvasTableViewController
            destination.delegate = self.delegate
        } else if segue.identifier == CreatePageFromExistingController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! CreatePageFromExistingController
            destination.user = self.user
            destination.delegate = self.delegate
        }
    }
}