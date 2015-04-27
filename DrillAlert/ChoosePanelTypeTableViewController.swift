//
//  ChoosePanelTypeTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ChoosePanelTypeNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String! {
        return "ChoosePanelTypeNavigationController"
    }
}

class ChoosePanelTypeTableViewController: UITableViewController {
    var user: User!
    var wellbore: Wellbore!
    var delegate: AddEditLayoutTableViewController!
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func storyboardIdentifier() -> String! {
        return "ChoosePanelTypeTableViewController"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddEditPlotTableViewController.addPlotEntrySegueIdentifier() {
            let destination = segue.destinationViewController as! AddEditPlotTableViewController
            destination.delegate = self.delegate
        }
    }
}