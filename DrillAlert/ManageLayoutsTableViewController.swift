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

class ManageLayoutsNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String! {
        return "ManageLayoutsNavigationController"
    }
}

class ManageLayoutsTableViewController: UITableViewController {

    // Implicit, set by the previous view controller
    var user: User!
    var wellbore: Wellbore!
    var currentLayout: Layout?
    var wellboreDetailViewController: WellboreDetailViewController!
    
    
    @IBOutlet weak var currentLayoutTableViewCell: UITableViewCell!
    
    @IBAction func createNewLayoutButtonTapped(sender: UIButton) {
        self.presentAddLayoutTableViewController()
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.title = "Layouts"
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ManageLayoutsTableViewController"
    }
    
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var vc = storyboard.instantiateViewControllerWithIdentifier("EditViewsTableViewController") as! EditViewsTableViewController
        vc.wellboreDetailViewController = self.wellboreDetailViewController
        let navigationController = UINavigationController(rootViewController: vc as UIViewController)
        self.presentViewController(navigationController, animated: false, completion: nil)
        */
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ChangeLayoutTableViewController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! ChangeLayoutTableViewController
            destination.wellbore = self.wellbore
            destination.user = self.user
            destination.selectedLayout = self.currentLayout
            destination.manageLayoutsTableViewController = self
        } else if segue.identifier == EditLayoutsTableViewController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! EditLayoutsTableViewController
            destination.wellbore = self.wellbore
            destination.user = self.user
        }
        
        /*
        let wellbore = sender as! Wellbore
        let destinationViewController = segue.destinationViewController as! WellboreDetailViewController
        destinationViewController.currentWellbore = wellbore
        */
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    func presentAddLayoutTableViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        let addEditLayoutNavigationController = storyboard.instantiateViewControllerWithIdentifier(
            AddEditLayoutNavigationController.storyboardIdentifier()) as! AddEditLayoutNavigationController
        // Get the first child of the navigation controller
        let addEditLayoutTableViewController = addEditLayoutNavigationController.viewControllers[0] as! AddEditLayoutTableViewController
        
        // Set the required variables
        addEditLayoutTableViewController.wellbore = self.wellbore
        addEditLayoutTableViewController.user = self.user
        
        // Show the navigation controller
        self.presentViewController(addEditLayoutNavigationController, animated: true, completion: nil)
    }

}















