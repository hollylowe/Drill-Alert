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
    
    // Segmented Control
    let segmentedControlItems = ["Subscribed", "All"]
    var selectedSegmentIndex = 0
    let subscribedWellsIndex = 0
    let allWellsIndex = 1

    var loggedIn = false
    var subscribedWells = Array<Well>()
    var allWells = Array<Well>()
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
    }
    
    private func setupView() {
        let toolbarWidth = self.view.frame.size.width
        let toolbarHeight: CGFloat = 44.0

        if let navBar = self.navigationController {
            // Add the tab bar at the (navigation bar height + status bar height) y coordinate
            let yCoord = navBar.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            
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
            
        }
        
        // Sets the tableview y coordinate to the toolbarheight
        let headerViewRect = CGRectMake(0, 0, self.tableView.frame.width, toolbarHeight)
        self.tableView.tableHeaderView = UIView(frame: headerViewRect)
    }
    
    func segmentedControlAction(sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        self.reloadWells()
    }
    
    override func viewDidAppear(animated: Bool) {
        if !loggedIn {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let identifier = LoginViewController.storyboardIdentifier()
            let loginViewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as LoginViewController
            
            loginViewController.delegate = self
            self.presentViewController(loginViewController, animated: false, completion: nil)
        }
        super.viewDidAppear(animated)
        
    }

    func reloadWells() {
        // Only load the wells of the currently selected segment.
        if selectedSegmentIndex == subscribedWellsIndex {
            subscribedWells = Well.getSubscribedWellsForUserID("117")
        } else {
            allWells = Well.getAllWellsForUserID("117")
        }
        
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WellCell") as UITableViewCell
        var well: Well
        
        if selectedSegmentIndex == subscribedWellsIndex {
            well = subscribedWells[indexPath.row]
        } else {
            well = allWells[indexPath.row]
        }
        
        cell.textLabel.text = well.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if selectedSegmentIndex == subscribedWellsIndex {
            count = subscribedWells.count
        } else {
            count = allWells.count
        }
        return count
    }
}

extension HomeViewController: UITableViewDelegate {
    
    
    
}