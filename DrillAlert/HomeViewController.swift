//
//  HomeViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let homeToAdminSegueIdentifier = "HomeToAdminSegue"
    let homeToWellboreDetailSegueIdentifier = "WellboreDetailSegue"
    
    // Segmented Control
    let segmentedControlItems = ["Subscribed", "All"]
    var selectedSegmentIndex = 0
    let subscribedWellboresIndex = 0
    let allWellsIndex = 1

    // Implicit since the user must be logged in to see the HomeViewController.
    var currentUser: User!
    
    // Data for the table view
    var subscribedWellbores = Array<Wellbore>()
    var allWellbores = Array<Wellbore>()
    
    override func viewDidLoad() {
        setupView()
        reloadWells()
        super.viewDidLoad()
    }
    
    private func setupView() {
        self.title = "Home"
        let toolbarWidth = self.view.frame.size.width
        let toolbarHeight: CGFloat = 44.0

        if let navigationController = self.navigationController {
            navigationController.navigationBar.hidden = false
            // Add the segmented control at the (navigation bar height + status bar height) y coordinate
            let yCoord = navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            
            // Set up Toolbar
            let toolbarRect = CGRectMake(0, yCoord, toolbarWidth, toolbarHeight)
            let toolbar = UIToolbar(frame: toolbarRect)
            
            // Set up Segmented Control
            let segmentedControlHeight: CGFloat = 29.0
            let segmentedControlWidth: CGFloat = toolbarWidth / 2
            let segmentedControlXCoord: CGFloat = toolbarWidth / 4
            let segmentedControlYCoord: CGFloat = (toolbarHeight - segmentedControlHeight) / 2
            
            let segmentedControlRect = CGRectMake(
                segmentedControlXCoord,
                segmentedControlYCoord,
                segmentedControlWidth,
                segmentedControlHeight)
            
            
            let segmentedControl = UISegmentedControl(items: segmentedControlItems)
            segmentedControl.frame = segmentedControlRect
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(
                self,
                action: Selector("segmentedControlAction:"),
                forControlEvents: .ValueChanged)
                
            toolbar.addSubview(segmentedControl)
            toolbar.addBottomBorder()
            
            self.view.addSubview(toolbar)
            // Sets the tableview y coordinate to the toolbarheight
            
            let headerViewRect = CGRectMake(0, 0, self.tableView.frame.width, toolbarHeight + yCoord)
            self.tableView.tableHeaderView = UIView(frame: headerViewRect)
        }
       
    }
    
    func adminBarButtonTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier(homeToAdminSegueIdentifier, sender: self)
    }
    
    func segmentedControlAction(sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        self.reloadWells()
    }

    func reloadWells() {
        // Only load the wells of the currently selected segment.
        if selectedSegmentIndex == subscribedWellboresIndex {
            subscribedWellbores = Wellbore.getSubscribedWellboresForUserID(currentUser.id)
        } else {
            allWellbores = Wellbore.getAllWellboresForUserID(currentUser.id)
        }
        
        tableView.reloadData()
    }
    
    func wellboreAtIndex(index: Int) -> Wellbore {
        var wellbore: Wellbore!
        
        if selectedSegmentIndex == subscribedWellboresIndex {
            wellbore = subscribedWellbores[index]
        } else {
            wellbore = allWellbores[index]
        }
        
        return wellbore
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == homeToWellboreDetailSegueIdentifier {
            let wellbore = sender as Wellbore
            let destinationViewController = segue.destinationViewController as WellboreDetailTabBarController
            destinationViewController.currentWellbore = wellbore
            
        }
        super.prepareForSegue(segue, sender: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WellCell") as UITableViewCell
        let wellbore = wellboreAtIndex(indexPath.row)
        
        cell.textLabel.text = wellbore.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if selectedSegmentIndex == subscribedWellboresIndex {
            count = subscribedWellbores.count
        } else {
            count = allWellbores.count
        }
        return count
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let wellbore = wellboreAtIndex(indexPath.row)
        
        self.performSegueWithIdentifier(homeToWellboreDetailSegueIdentifier, sender: wellbore)
    }
}