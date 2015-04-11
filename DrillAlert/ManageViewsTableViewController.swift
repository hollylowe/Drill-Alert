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
    var selectedView: View!
    
    override func viewDidLoad() {
        self.title = "Change Layout"
        self.tableView.rowHeight = 65
        
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var vc = storyboard.instantiateViewControllerWithIdentifier("EditViewsTableViewController") as! EditViewsTableViewController
        vc.wellboreDetailViewController = self.wellboreDetailViewController
        let navigationController = UINavigationController(rootViewController: vc as UIViewController)
        self.presentViewController(navigationController, animated: false, completion: nil)
    }
    
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
      
            let wellbore = sender as! Wellbore
            let destinationViewController = segue.destinationViewController as! WellboreDetailViewController
            destinationViewController.currentWellbore = wellbore
        
        super.prepareForSegue(segue, sender: self)
    }

}

extension ManageViewsTableViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ViewTableViewCell.cellIdentifier()) as! ViewTableViewCell
        let view = views[indexPath.row]
        
        if let s = self.selectedView {
            if (s.equals(view)){
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                self.selectedView = view
            }
        }
        
        if (view.currentView)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.selectedView = view
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
        let view = views[indexPath.row] as View
        let cell = tableView.dequeueReusableCellWithIdentifier(ViewTableViewCell.cellIdentifier()) as! ViewTableViewCell
        
        
        self.selectedView = view
        view.currentView = true
        
        
        cell.accessoryType = .Checkmark
        
        for otherView in views{
            if (!otherView.equals(view)){
                otherView.currentView = false
            }
        }
        tableView.reloadData()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
}

















