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
    
    let homeToWellboreDetailSegueIdentifier = "HomeToWellboreDetailSegue"
    
    // Segmented Control
    let segmentedControlItems = ["Subscribed", "All"]
    var selectedSegmentIndex = 0
    let subscribedWellboresIndex = 0
    let allWellsIndex = 1

    // Hiding the navigation bar line 
    var navBarHairlineImageView: UIImageView!
    
    // Implicit since the user must be logged in to see the HomeViewController.
    var currentUser: User!
    
    // Data for the table view
    var wells = Array<Well>()
    
    //var subscribedWellbores = Array<Wellbore>()
    //var allWellbores = Array<Wellbore>()
    
    // Variables for loading
    var loadingData = true
    var loadError = false
    
    // TODO: Remove, for debugging only
    var shouldLoadFromNetwork = true
    
    override func viewDidLoad() {
        setupView()
        loadData()
        super.viewDidLoad()
    }
    
    func loadData() {
        loadError = false
        loadingData = false
        
        if shouldLoadFromNetwork {
            loadError = false
            loadingData = true
            self.tableView.reloadData()
            
            // TODO: This will need to change if we add a way to refresh this page, which we probably will.
            // Instead, we could use the NSURLConnection asynchrounous call. This is because users could
            // refresh the page faster than this call could load it, resulting in multiple threads doing
            // the same operation and messing up the table view.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.reloadWells()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadingData = false
                    self.tableView.reloadData()
                })
            })

        } else {
            // allWellbores.append()
            // subscribedWellbores.append(Wellbore(id: 0, name: "Test Bore", well: Well(id: 0, name: "Test Well", location: "Here")))
            let well = Well(id: 0, name: "Test Well", location: "No Location")
            well.wellbores.append(Wellbore(id: 0, name: "Test Bore", well: Well(id: 0, name: "Test Well", location: "Here")))
            
            self.wells.append(well)
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding the navigation bar line
        if let navigationController = self.navigationController {
            navBarHairlineImageView = self.findHairlineImageViewUnder(navigationController.navigationBar)
            navBarHairlineImageView.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navBarHairlineImageView.hidden = false
    }
    
    func logoutButtonTapped(sender: UIBarButtonItem) {
        currentUser.logout()
        
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
        }
    }
    
    private func setupView() {
        self.title = "Wellbores"
        let toolbarWidth = self.view.frame.size.width
        let toolbarHeight: CGFloat = 39.0

        // Setup refresh control
        // self.tableView.addSubview(UIRefreshControl())
        // self.tableView.backgroundColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        // self.tableView.separatorColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.hidden = false
            
            // Disable the back button
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
            self.navigationItem.hidesBackButton = true
            
            let logoutButton = UIBarButtonItem(title: "Logout", style: .Bordered, target: self, action: "logoutButtonTapped:")
            
            if let image = UIImage(named: "logouticon.png") {
                let logoutImage = imageWithImage(image, scaledToSize: CGSize(width: 40, height: 40))
                logoutButton.image = logoutImage
            }
            
            
            self.navigationItem.leftBarButtonItem = logoutButton
            
            // Add the segmented control at the (navigation bar height + status bar height) y coordinate
            let yCoord = navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            
            // let yCoord: CGFloat = 0
            // let toolbarColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            // Set up Toolbar
            let toolbarRect = CGRectMake(0, yCoord, toolbarWidth, toolbarHeight)
            let toolbar = UIToolbar(frame: toolbarRect)
            //  toolbar.backgroundColor = toolbarColor
            // toolbar.translucent = false
            // toolbar.barTintColor =  UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
            
            // Set up Segmented Control
            let segmentedControlHeight: CGFloat = 24.0
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
            let headerViewRect = CGRectMake(0, 0, self.tableView.frame.width, toolbarHeight)
            // self.tableView.tableHeaderView = UIView(frame: headerViewRect)
            self.tableView.contentInset = UIEdgeInsets(top: toolbarHeight, left: 0, bottom: 0, right: 0)
        }
       
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        } else {
            for subview in view.subviews {
                var imageView = self.findHairlineImageViewUnder(subview as UIView)
                if imageView != nil {
                    return imageView
                }
            }
            return nil
        }
    }
    
    func segmentedControlAction(sender: UISegmentedControl) {
        self.selectedSegmentIndex = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }

    func reloadWells() {
        
        


        // Only load the wells of the currently selected segment.
        // TODO: Not sure if API is supporting this, we may remove it. For right now, just set both
        // allWellbores.removeAll(keepCapacity: false)
        // subscribedWellbores.removeAll(keepCapacity: false)
        self.wells.removeAll(keepCapacity: false)
        
        let (newWells, error) = Well.getWellsForUser(currentUser)
        
        if error == nil {
            /*
            for well in wells {
                for wellbore in well.wellbores {
                    subscribedWellbores.append(wellbore)
                    // allWellbores.append(wellbore)
                }
            }
            */
            self.wells = newWells
        } else {
            self.loadError = true
            
            var alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func wellboreAtIndexPath(indexPath: NSIndexPath) -> Wellbore {
        var wellbore: Wellbore!
        
        let well = self.wells[indexPath.section]
        if well.wellbores.count > 0 {
            wellbore = well.wellbores[indexPath.row]
        }
        
        
        /*
        if selectedSegmentIndex == subscribedWellboresIndex {
            wellbore = subscribedWellbores[index]
        } else {
            wellbore = allWellbores[index]
        }
        */
        
        
        return wellbore
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == homeToWellboreDetailSegueIdentifier {
            let wellbore = sender as Wellbore
            let destinationViewController = segue.destinationViewController as WellboreDetailViewController
            destinationViewController.currentWellbore = wellbore
            destinationViewController.currentUser = currentUser
        }
        
        super.prepareForSegue(segue, sender: self)
    }
}


extension HomeViewController: UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("WellTableViewCell") as WellTableViewCell
        let well = wells[section]
        
        cell.setupWithWell(well)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        
        let cell = tableView.dequeueReusableCellWithIdentifier(WellboreTableViewCell.getCellIdentifier()) as WellboreTableViewCell
        let wellbore = wellboreAtIndexPath(indexPath)
        
        cell.setupWithWellbore(wellbore)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        let well = self.wells[section]
        count = well.wellbores.count
        /*
        if selectedSegmentIndex == subscribedWellboresIndex {
            count = subscribedWellbores.count
        } else {
            count = allWellbores.count
        }
        */
        
        return count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 57.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections = 1
        
        if loadingData {
            sections = 0
            let indicatorWidth: CGFloat = 20
            let indicatorHeight: CGFloat = 20
            // Display loading indicator
            var backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake((self.view.bounds.size.width - indicatorWidth) / 2, (self.view.bounds.size.height - indicatorHeight) / 2, indicatorWidth, indicatorHeight))
            
            loadingIndicator.color = UIColor.grayColor()
            loadingIndicator.startAnimating()
            backgroundView.addSubview(loadingIndicator)
            self.tableView.backgroundView = backgroundView
            self.tableView.separatorStyle = .None

        } else {
            
            if (selectedSegmentIndex == subscribedWellboresIndex && wells.count == 0) || (selectedSegmentIndex == allWellsIndex && wells.count == 0) {
                sections = 0
                
                // Display "No Wells" message
                let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                var noWellsLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
                if loadError {
                    noWellsLabel.text = "Network Error"
                } else {
                    noWellsLabel.text = "No Wellbores"
                }
                
                noWellsLabel.textColor = textColor
                noWellsLabel.numberOfLines = 0
                noWellsLabel.textAlignment = .Center
                noWellsLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
                noWellsLabel.sizeToFit()
                
                self.tableView.backgroundView = noWellsLabel
                self.tableView.separatorStyle = .None
            } else {
                sections = self.wells.count
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = .SingleLine
            }

        }
        
        return sections
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let wellbore = wellboreAtIndexPath(indexPath)
        
        
        self.performSegueWithIdentifier(homeToWellboreDetailSegueIdentifier, sender: wellbore)
    }
}



//  HomeViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.


//import Foundation
//import UIKit
//
//class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    @IBOutlet weak var tableView: UITableView!
//    
//    let homeToWellboreDetailSegueIdentifier = "HomeToWellboreDetailSegue"
//    
//    // Segmented Control
//    let segmentedControlItems = ["Subscribed", "All"]
//    var selectedSegmentIndex = 0
//    let subscribedWellboresIndex = 0
//    let allWellsIndex = 1
//    
//    // Hiding the navigation bar line
//    var navBarHairlineImageView: UIImageView!
//    
//    // Implicit since the user must be logged in to see the HomeViewController.
//    var currentUser: User!
//    
//    // Data for the table view
//    var subscribedWellbores = Array<Wellbore>()
//    var allWellbores = Array<Wellbore>()
//    
//    // Variables for loading
//    var loadingData = true
//    var loadError = false
//    
//    override func viewDidLoad() {
//        setupView()
//        loadData()
//        super.viewDidLoad()
//    }
//    
//    func loadData() {
//        loadError = false
//        loadingData = false
//        
//        // FOR TESTING
//        allWellbores.append(Wellbore(id: 0, name: "Test Bore", well: Well(id: 0, name: "Test Well", location: "Here")))
//        subscribedWellbores.append(Wellbore(id: 0, name: "Test Bore", well: Well(id: 0, name: "Test Well", location: "Here")))
//        
//        
//        self.tableView.reloadData()
//        
//        /*
//        FOR NETWORK LOAD, DELETE THE ABOVE, AND UNCOMMENT THIS
//        
//        loadError = false
//        loadingData = true
//        self.tableView.reloadData()
//        
//        // TODO: This will need to change if we add a way to refresh this page, which we probably will.
//        // Instead, we could use the NSURLConnection asynchrounous call. This is because users could
//        // refresh the page faster than this call could load it, resulting in multiple threads doing
//        // the same operation and messing up the table view.
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//        self.reloadWells()
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        self.loadingData = false
//        self.tableView.reloadData()
//        })
//        })
//        */
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        // Hiding the navigation bar line
//        if let navigationController = self.navigationController {
//            navBarHairlineImageView = self.findHairlineImageViewUnder(navigationController.navigationBar)
//            navBarHairlineImageView.hidden = true
//        }
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        navBarHairlineImageView.hidden = false
//    }
//    
//    func logoutButtonTapped(sender: UIBarButtonItem) {
//        currentUser.logout()
//        
//        if let navigationController = self.navigationController {
//            navigationController.popToRootViewControllerAnimated(true)
//        }
//    }
//    
//    private func setupView() {
//        self.title = "Wellbores"
//        let toolbarWidth = self.view.frame.size.width
//        let toolbarHeight: CGFloat = 39.0
//        
//        // Setup refresh control
//        self.tableView.addSubview(UIRefreshControl())
//        
//        if let navigationController = self.navigationController {
//            navigationController.navigationBar.hidden = false
//            
//            // Disable the back button
//            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
//            self.navigationItem.hidesBackButton = true
//            
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Bordered, target: self, action: "logoutButtonTapped:")
//            
//            // Add the segmented control at the (navigation bar height + status bar height) y coordinate
//            let yCoord = navigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
//            
//            // Set up Toolbar
//            let toolbarRect = CGRectMake(0, yCoord, toolbarWidth, toolbarHeight)
//            let toolbar = UIToolbar(frame: toolbarRect)
//            
//            // Set up Segmented Control
//            let segmentedControlHeight: CGFloat = 24.0
//            let segmentedControlWidth: CGFloat = toolbarWidth / 2
//            let segmentedControlXCoord: CGFloat = toolbarWidth / 4
//            let segmentedControlYCoord: CGFloat = (toolbarHeight - segmentedControlHeight) / 2
//            
//            let segmentedControlRect = CGRectMake(
//                segmentedControlXCoord,
//                segmentedControlYCoord,
//                segmentedControlWidth,
//                segmentedControlHeight)
//            
//            
//            let segmentedControl = UISegmentedControl(items: segmentedControlItems)
//            segmentedControl.frame = segmentedControlRect
//            segmentedControl.selectedSegmentIndex = 0
//            segmentedControl.addTarget(
//                self,
//                action: Selector("segmentedControlAction:"),
//                forControlEvents: .ValueChanged)
//            
//            toolbar.addSubview(segmentedControl)
//            toolbar.addBottomBorder()
//            
//            self.view.addSubview(toolbar)
//            
//            // Sets the tableview y coordinate to the toolbarheight
//            let headerViewRect = CGRectMake(0, 0, self.tableView.frame.width, toolbarHeight)
//            self.tableView.tableHeaderView = UIView(frame: headerViewRect)
//        }
//        
//    }
//    
//    func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
//        if view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1.0 {
//            return view as? UIImageView
//        } else {
//            for subview in view.subviews {
//                var imageView = self.findHairlineImageViewUnder(subview as UIView)
//                if imageView != nil {
//                    return imageView
//                }
//            }
//            return nil
//        }
//    }
//    
//    func segmentedControlAction(sender: UISegmentedControl) {
//        self.selectedSegmentIndex = sender.selectedSegmentIndex
//        self.tableView.reloadData()
//    }
//    
//    func reloadWells() {
//        
//        /*
//        FOR NETWORK LOAD, UNCOMMENT THIS
//        // Only load the wells of the currently selected segment.
//        // TODO: Not sure if API is supporting this, we may remove it. For right now, just set both
//        allWellbores.removeAll(keepCapacity: false)
//        subscribedWellbores.removeAll(keepCapacity: false)
//        let (wells, error) = Well.getWellsForUserID(currentUser.id)
//        
//        if error == nil {
//        for well in wells {
//        for wellbore in well.wellbores {
//        subscribedWellbores.append(wellbore)
//        // allWellbores.append(wellbore)
//        }
//        }
//        } else {
//        self.loadError = true
//        
//        var alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
//        }
//        
//        */
//    }
//    
//    func wellboreAtIndex(index: Int) -> Wellbore {
//        var wellbore: Wellbore!
//        
//        if selectedSegmentIndex == subscribedWellboresIndex {
//            wellbore = subscribedWellbores[index]
//        } else {
//            wellbore = allWellbores[index]
//        }
//        
//        return wellbore
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == homeToWellboreDetailSegueIdentifier {
//            let wellbore = sender as Wellbore
//            let destinationViewController = segue.destinationViewController as WellboreDetailViewController
//            destinationViewController.currentWellbore = wellbore
//            destinationViewController.currentUser = currentUser
//        }
//        
//        super.prepareForSegue(segue, sender: self)
//    }
//}
//
//
//extension HomeViewController: UITableViewDataSource {
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(WellboreTableViewCell.getCellIdentifier()) as WellboreTableViewCell
//        let wellbore = wellboreAtIndex(indexPath.row)
//        
//        cell.setupWithWellbore(wellbore)
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = 0
//        if selectedSegmentIndex == subscribedWellboresIndex {
//            count = subscribedWellbores.count
//        } else {
//            count = allWellbores.count
//        }
//        return count
//    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        var sections = 1
//        
//        if loadingData {
//            sections = 0
//            let indicatorWidth: CGFloat = 20
//            let indicatorHeight: CGFloat = 20
//            // Display loading indicator
//            var backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
//            var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake((self.view.bounds.size.width - indicatorWidth) / 2, (self.view.bounds.size.height - indicatorHeight) / 2, indicatorWidth, indicatorHeight))
//            
//            loadingIndicator.color = UIColor.grayColor()
//            loadingIndicator.startAnimating()
//            backgroundView.addSubview(loadingIndicator)
//            self.tableView.backgroundView = backgroundView
//            self.tableView.separatorStyle = .None
//            
//        } else {
//            
//            if (selectedSegmentIndex == subscribedWellboresIndex && subscribedWellbores.count == 0) || (selectedSegmentIndex == allWellsIndex && allWellbores.count == 0) {
//                sections = 0
//                
//                // Display "No Wells" message
//                let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
//                var noWellsLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
//                if loadError {
//                    noWellsLabel.text = "Network Error"
//                } else {
//                    noWellsLabel.text = "No Wellbores"
//                }
//                
//                noWellsLabel.textColor = textColor
//                noWellsLabel.numberOfLines = 0
//                noWellsLabel.textAlignment = .Center
//                noWellsLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
//                noWellsLabel.sizeToFit()
//                
//                self.tableView.backgroundView = noWellsLabel
//                self.tableView.separatorStyle = .None
//            } else {
//                self.tableView.backgroundView = nil
//                self.tableView.separatorStyle = .SingleLine
//            }
//            
//        }
//        
//        return sections
//    }
//}
//
//extension HomeViewController: UITableViewDelegate {
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let wellbore = wellboreAtIndex(indexPath.row)
//        
//        self.performSegueWithIdentifier(homeToWellboreDetailSegueIdentifier, sender: wellbore)
//    }
//}
