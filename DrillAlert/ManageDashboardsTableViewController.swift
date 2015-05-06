//
//  ManageViewsTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

//TODO populate this view with a custom table cell that is a name of a visual and switch that indicates if it will show up on the home screen or not. 

class ManageDashboardsNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String! {
        return "ManageDashboardsNavigationController"
    }
}

class ManageDashboardsTableViewController: UITableViewController {

    // Implicit, set by the previous view controller
    var user: User!
    var wellbore: Wellbore!
    var currentDashboard: Dashboard?
    var wellboreDetailViewController: WellboreDetailViewController!
    
    
    @IBOutlet weak var currentLayoutTableViewCell: UITableViewCell!
    
    @IBAction func createNewLayoutButtonTapped(sender: UIButton) {
        self.presentAddDashboardTableViewController()
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.title = "Dashboards"
        if let dashboard = self.currentDashboard {
            if let label = self.currentLayoutTableViewCell.detailTextLabel {
                label.text = dashboard.name
            }
        }
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ManageDashboardsTableViewController"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ChangeDashboardTableViewController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! ChangeDashboardTableViewController
            destination.wellbore = self.wellbore
            destination.user = self.user
            println("Wellbore for manage: \(self.wellbore)")
            println("User for manage: \(self.user)")
            
            destination.selectedDashboard = self.currentDashboard
            destination.manageDashboardsTableViewController = self
            
        } else if segue.identifier == EditDashboardsTableViewController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! EditDashboardsTableViewController
            destination.wellbore = self.wellbore
            destination.user = self.user
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    func presentAddDashboardTableViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        let addEditDashboardNavigationController = storyboard.instantiateViewControllerWithIdentifier(
            AddEditDashboardNavigationController.storyboardIdentifier()) as! AddEditDashboardNavigationController
        // Get the first child of the navigation controller
        let addEditDashboardTableViewController = addEditDashboardNavigationController.viewControllers[0] as! AddEditDashboardTableViewController
        
        // Set the required variables
        addEditDashboardTableViewController.wellbore = self.wellbore
        addEditDashboardTableViewController.user = self.user
        
        // Show the navigation controller
        self.presentViewController(addEditDashboardNavigationController, animated: true, completion: nil)
    }

}















