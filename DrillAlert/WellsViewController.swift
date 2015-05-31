//
//  WellsViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit



class WellsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let homeToWellboreDetailSegueIdentifier = "HomeToWellboreDetailSegue"
    
    // Segmented Control
    let segmentedControlItems = ["All", "Favorites"]
    var selectedSegmentIndex  = 0
    var selectedWellIndex: Int?
    let allWellsIndex         = 0
    let favoriteWellsIndex    = 1
    
    var defaultRowHeight:    CGFloat = 57.0
    var sectionFooterHeight: CGFloat = 1.0
    var sectionHeaderHeight: CGFloat = 62.0
    
    // Variables for loading
    var loadingData = true
    var loadError   = false
    var user: User!
    var wellContainer: WellContainer!
    
    override func viewDidAppear(animated: Bool) {
        if let homeTabBarController = self.tabBarController as? HomeTabBarController {
            homeTabBarController.changeTitle("Wells")
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh,
                target: self,
                action: "refresh:")
            refreshButton.tintColor = UIColor.SDIBlue()
            homeTabBarController.navigationItem.setRightBarButtonItem(refreshButton, animated: false)
        }
        if let navLine = self.navBarHairlineImageView {
            navLine.hidden = true
        }
        super.viewDidAppear(animated)
    }
    
    func refresh(sender: AnyObject) {
        self.loadData()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        if let homeTabBarController = self.tabBarController as? HomeTabBarController {
            self.user = homeTabBarController.user
        }
        self.wellContainer = WellContainer()
        self.setupView()
        self.loadData()
        super.viewDidLoad()
    }
    
    func loadData() {
        loadError = false
        loadingData = true
        self.tableView.reloadData()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.reloadWells()
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.loadingData = false
                self.tableView.reloadData()
            })
        })
    }
    
    private func setupView() {
        self.tableView.backgroundColor = UIColor.blackColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.blackColor()

        let toolbarWidth = self.view.frame.size.width
        let toolbarHeight: CGFloat = 44.0
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.hidden = false
            navigationController.navigationBar.barStyle = UIBarStyle.Black
            
            // Add the segmented control at the (navigation bar height + status bar height) y coordinate
            let yCoord = navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            
            let toolbarRect = CGRectMake(0, yCoord, toolbarWidth, toolbarHeight + 5.0)
            let toolbar = UIToolbar(frame: toolbarRect)
            toolbar.barTintColor = UIColor(red: 0.096, green: 0.096, blue: 0.096, alpha: 1.0)
            // Set up Segmented Control
            let segmentedControlHeight: CGFloat = 30.0
            let segmentedControlWidth: CGFloat = toolbarWidth - (toolbarWidth / 4)
            let segmentedControlXCoord: CGFloat = toolbarWidth / 8
            let segmentedControlYCoord: CGFloat = (toolbarHeight - segmentedControlHeight) / 2
            let segmentedControlRect = CGRectMake(
                segmentedControlXCoord,
                segmentedControlYCoord,
                segmentedControlWidth,
                segmentedControlHeight)
            
            
            let segmentedControl = UISegmentedControl(items: segmentedControlItems)
            segmentedControl.tintColor = UIColor.whiteColor()
            segmentedControl.frame = segmentedControlRect
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(
                self,
                action: Selector("segmentedControlAction:"),
                forControlEvents: .ValueChanged)
            toolbar.addSubview(segmentedControl)
            //toolbar.addBottomBorder()
            
            self.view.addSubview(toolbar)
            
            // Sets the tableview y coordinate to the toolbarheight
            let headerViewRect = CGRectMake(0, 0, self.tableView.frame.width, toolbarHeight + 5.0 + UIApplication.sharedApplication().statusBarFrame.size.height)
            // self.tableView.tableHeaderView = UIView(frame: headerViewRect)
            self.tableView.contentInset = UIEdgeInsets(top: toolbarHeight + 5.0 + yCoord, left: 0, bottom: 0, right: 0)
            
        }
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navBarHairlineImageView?.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navBarHairlineImageView?.hidden = false
    }
    
    func segmentedControlAction(sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    func reloadWells() {
        let error = self.wellContainer.reloadWellsForUser(self.user)
        
        if error != nil {
            self.loadError = true
            
            var alert = UIAlertController(
                title: "Error",
                message: error,
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func wellboreAtIndexPath(indexPath: NSIndexPath) -> Wellbore {
        var wellbore: Wellbore!
        
        if selectedSegmentIndex == favoriteWellsIndex {
            let well = self.wellContainer.favoriteWells[indexPath.section]
            if well.wellbores.count > 0 {
                wellbore = well.wellbores[indexPath.row]
            }
        } else {
            let well = self.wellContainer.wells[indexPath.section]
            if well.wellbores.count > 0 {
                wellbore = well.wellbores[indexPath.row]
            }
        }
        
        return wellbore
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == homeToWellboreDetailSegueIdentifier {
            let wellbore = sender as! Wellbore
            let destinationViewController = segue.destinationViewController as! WellboreDetailViewController
            destinationViewController.currentWellbore = wellbore
            destinationViewController.currentUser = user
        }
        
        super.prepareForSegue(segue, sender: self)
    }
}


extension WellsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WellboreTableViewCell.getCellIdentifier()) as! WellboreTableViewCell
        let wellbore = wellboreAtIndexPath(indexPath)
        
        cell.setupWithWellbore(wellbore)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if selectedSegmentIndex == favoriteWellsIndex {
            let well = self.wellContainer.favoriteWells[section]
            count = well.wellbores.count
        } else {
            let well = self.wellContainer.wells[section]
            count = well.wellbores.count
        }
        
        return count
    }
    
    private func showNoWellsView() {
        let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        var noWellsLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        if loadError {
            noWellsLabel.text = "Network Error"
        } else {
            if selectedSegmentIndex == favoriteWellsIndex {
                noWellsLabel.text = "No Favorite Wells"
            } else {
                noWellsLabel.text = "No Wells"
            }
        }
        
        noWellsLabel.textColor = textColor
        noWellsLabel.numberOfLines = 0
        noWellsLabel.textAlignment = .Center
        noWellsLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
        noWellsLabel.sizeToFit()
        
        self.tableView.backgroundView = noWellsLabel
    }
    
    private func showLoadingView() {
        let indicatorWidth: CGFloat = 20
        let indicatorHeight: CGFloat = 20
        // Display loading indicator
        var backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake((self.view.bounds.size.width - indicatorWidth) / 2, (self.view.bounds.size.height - indicatorHeight) / 2, indicatorWidth, indicatorHeight))
        
        loadingIndicator.color = UIColor.grayColor()
        loadingIndicator.startAnimating()
        backgroundView.addSubview(loadingIndicator)
        self.tableView.backgroundView = backgroundView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 1
        
        if loadingData {
            numberOfSections = 0
            self.showLoadingView()
        } else {
            
            if (selectedSegmentIndex == favoriteWellsIndex && wellContainer.favoriteWells.count == 0) || (selectedSegmentIndex == allWellsIndex && wellContainer.wells.count == 0) {
                numberOfSections = 0
                self.showNoWellsView()
            } else {
                if selectedSegmentIndex == favoriteWellsIndex {
                    numberOfSections = self.wellContainer.favoriteWells.count
                } else {
                    numberOfSections = self.wellContainer.wells.count
                }
                
                self.tableView.backgroundView = nil
            }

        }
        
        return numberOfSections
    }
}

extension WellsViewController: UITableViewDelegate {
    /*
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRectMake(0, 61.0, self.tableView.frame.size.width, 1.0))
        view.backgroundColor = UIColor(red: 0.221, green: 0.221, blue: 0.221, alpha: 1.0)
        return view
    }
    */
    
    func sectionTapped(sender: UITapGestureRecognizer) {
        // The sender view is the cell that was tapped, 
        // aka the section header.
        if let sectionView = sender.view {
            let newSelectedWellIndex = sectionView.tag
            if let tappedCell = sectionView.subviews[0] as? WellTableViewCell {
                // This tag is the section index that was tapped.
                // If we have a previously selected well...
                if let currentIndex = self.selectedWellIndex {
                    // and if that well is equal to the well
                    // that was just selected...
                    if currentIndex == newSelectedWellIndex {
                        // Then deselect the well by making
                        // the selected well index and last selected cell nil.
                        self.selectedWellIndex = nil
                        
                    } else {
                        // If the previously selected well is
                        // different than the one selected
                        //
                        // Select the new cell
                        self.selectedWellIndex = newSelectedWellIndex
                    }
                } else {
                    self.selectedWellIndex = newSelectedWellIndex
                }
                
                tableView.beginUpdates()
                tableView.endUpdates()
                
            }
        }
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("WellTableViewCell") as! WellTableViewCell
        var view = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, self.sectionHeaderHeight))
        var well: Well!
        
        if selectedSegmentIndex == favoriteWellsIndex {
            well = self.wellContainer.favoriteWells[section]
        } else {
            well = self.wellContainer.wells[section]
        }
        cell.setupWithWell(well)
        cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.sectionHeaderHeight - 1.0)
        view.tag = section
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "sectionTapped:"))
        
        view.addSubview(cell)
        return view
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat = 0
        if let wellIndex = self.selectedWellIndex {
            // A well is selected, so its wellbores should
            // be shown.
            if wellIndex == indexPath.section {
                rowHeight = self.defaultRowHeight
            }
        }
        
        return rowHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sectionHeaderHeight
    }
    /*
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.sectionFooterHeight
    }
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let wellbore = wellboreAtIndexPath(indexPath)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(homeToWellboreDetailSegueIdentifier, sender: wellbore)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var result: [AnyObject]?
        let wellbore = self.wellboreAtIndexPath(indexPath)
        
        if wellbore.isFavorite {
            let unfavoriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Unfavorite") { (rowAction, indexPath) -> Void in
                let wellbore = self.wellboreAtIndexPath(indexPath)
                
                if let favoriteWellbore = FavoriteWellbore.fetchFavoriteWellboreWithWellboreID(wellbore.id) {
                    favoriteWellbore.delete()
                }
                
                self.tableView.setEditing(false, animated: true)
                self.loadData()
            }
            result = [unfavoriteAction]
        } else {
            let favoriteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favorite") { (rowAction, indexPath) -> Void in
                let wellbore = self.wellboreAtIndexPath(indexPath)
                
                FavoriteWellbore.createNewInstance(wellbore.id)
                self.tableView.setEditing(false, animated: true)
                self.loadData()
            }
            result = [favoriteAction]
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

