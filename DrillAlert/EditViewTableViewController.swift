//
//  EditViewTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/18/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit



class EditViewTableViewController: UITableViewController {
    
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var visuals: [Visual]!
    var selectedView: View!
    
    override func viewDidLoad() {
        self.title = selectedView.name        
        
        self.tableView.rowHeight = 65
        
        visuals = Visual.getVisualsForUser(wellboreDetailViewController.currentUser, andWellbore: wellboreDetailViewController.currentWellbore)
        
        for v in visuals {
            println("OMG " + v.name)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarButtonItemTapped:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "leftBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "EditViewTableViewController"
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc = storyboard.instantiateViewControllerWithIdentifier("ChooseAddVisualTableViewController") as ChooseAddVisualTableViewController
        vc.wellboreDetailViewController = self.wellboreDetailViewController
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
extension EditViewTableViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(EditVisualTableViewCell.cellIdentifier()) as EditVisualTableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EditVisualTableViewCell", forIndexPath: indexPath) as EditVisualTableViewCell
        let visual = visuals[indexPath.row]
        cell.setupWithVisual(visual)
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visuals.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let visual = visuals[indexPath.row]
        print("you've selected \(visual.name)")
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var vc = storyboard.instantiateViewControllerWithIdentifier("EditViewTableViewController") as EditViewTableViewController
//        vc.wellboreDetailViewController = self.wellboreDetailViewController
//        vc.selectedView = view
//        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    //    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    //        let alert = alerts[indexPath.row]
    //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    //
    //        self.performSegueWithIdentifier(AddEditAlertNavigationController.getEntrySegueIdentifier(), sender: alert)
}















