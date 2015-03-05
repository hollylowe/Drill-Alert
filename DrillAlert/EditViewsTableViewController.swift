//
//  EditViewsTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/16/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class EditViewsTableViewController: UITableViewController {
    
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var views: [View]!
    
    override func viewDidLoad() {
        self.title = "Edit"
        
        
        self.tableView.rowHeight = 65

        views = View.getViewsForUser(wellboreDetailViewController.currentUser, andWellbore: wellboreDetailViewController.currentWellbore)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "leftBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "EditViewsTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        var vc = storyboard.instantiateViewControllerWithIdentifier("AddViewTableViewController") as AddViewTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func DoneButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        let wellbore = sender as Wellbore
        let destinationViewController = segue.destinationViewController as WellboreDetailViewController
        destinationViewController.currentWellbore = wellbore
        
        super.prepareForSegue(segue, sender: self)
    }
    
}

extension EditViewsTableViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EditViewTableViewCell.cellIdentifier()) as EditViewTableViewCell
        let view = views[indexPath.row]
        cell.setupWithView(view)
        
        return cell
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let view = views[indexPath.row]
        print("you've selected \(view.name)")
        
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var vc = storyboard.instantiateViewControllerWithIdentifier("EditViewTableViewController") as EditViewTableViewController
                vc.wellboreDetailViewController = self.wellboreDetailViewController
                vc.selectedView = view
                self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    //    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    //        let alert = alerts[indexPath.row]
    //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    //
    //        self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: alert)
}

















