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

class ManageViewsNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String! {
        return "ManageViewsNavigationController"
    }
}

class ManageViewsTableViewController: UITableViewController {

    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var views: [View]!
    
    override func viewDidLoad() {
        self.title = "Manage Views"
        
        views = View.getViewsForUser(wellboreDetailViewController.currentUser, andWellbore: wellboreDetailViewController.currentWellbore)
        for view in views{
            println ("\(view.name)")
        }
    
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "rightBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "leftBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ManageViewsTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        //TODO: this should change the items from switches to three lines and delete icons
//        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "AddButtonItemTapped:")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let addEditAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.getStoryboardIdentifier()) as AddEditAlertNavigationController
//        let addEditAlertViewController = addEditAlertNavigationController.viewControllers[0] as AddEditAlertTableViewController
//        addEditAlertViewController.delegate = self
//        self.presentViewController(addEditAlertNavigationController, animated: true, completion: nil)
        
    }
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        //TODO: save all currently set states? this might be controlled elsewhere
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func AddButtonItemTapped(sender: UIBarButtonItem) {
        print ("add a new visual")
        //TODO: Add functionality
    }
    
}

extension ManageViewsTableViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ViewTableViewCell.cellIdentifier()) as ViewTableViewCell
        let view = views[indexPath.row]
        if (view.currentView)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        cell.setupWithView(view)
        
        return cell
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tappedItem = views[indexPath.row] as View
        tappedItem.currentView = !tappedItem.currentView
        views[indexPath.row] = tappedItem
        
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        
//        let view = views[indexPath.row]
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        view.
        //self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: view)
    }
    
//    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
//        let alert = alerts[indexPath.row]
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: alert)
    }

















