//
//  WellboreDetailViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/29/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit


class WellboreDetailViewController: UIViewController {
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!

    var currentUser: User!
    var currentWellbore: Wellbore!
    var toolbarHeight: CGFloat = 44.0
    var toolbarYCoord: CGFloat = 0.0
    var dashboardNameViewHeight: CGFloat = 24.0
    var navBarHairlineImageView: UIImageView!
    
    // Segmented Control
    var segmentedControlToolbar: SegmentControlToolbar!
    var dashboardNameView: UIView!
    var dashboardNameLabel: UILabel!
    
    var segmentedControl: UISegmentedControl!
    let segmentedControlItems = ["Dashboards", "Alerts"]
    var segmentedControlViewControllers: [UIViewController]!
    var segmentNavigationController: UINavigationController!
    var containerView: UIView!
    
    // The two main view controllers for the segmented control
    var dashboardViewController: DashboardViewController!
    var manageAlertsVC: ManageAlertsTableViewController!
    
    // var alertInboxTableViewController: AlertInboxTableViewController!
    
    var selectedSegmentIndex = 0
    let dashboardIndex = 0
    let alertsIndex = 1
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navBarHairlineImageView.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navBarHairlineImageView.hidden = false
    }
    
    func updateCurrentDashboard(newDashboard: Dashboard) {
        self.dashboardViewController.updateCurrentDashboard(newDashboard)
        if let dashboard = self.dashboardViewController.currentDashboard {
            self.dashboardNameLabel.text = dashboard.name
        } else {
            self.dashboardNameLabel.text = "No Dashboard Selected"
        }
    }
    
    func updateCurrentDashboardLabelWithString(string: String) {
        self.dashboardNameLabel.text = string
    }
    
    private func setViewControllers() {
        // Instantiate the Dashboard View Controller
        // and the Alert Inbox View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.dashboardViewController = storyboard.instantiateViewControllerWithIdentifier(DashboardViewController.storyboardIdentifier()) as! DashboardViewController
        self.dashboardViewController.user = self.currentUser
        self.dashboardViewController.wellbore = self.currentWellbore
        self.dashboardViewController.wellboreDetailViewController = self
        
        self.manageAlertsVC = storyboard.instantiateViewControllerWithIdentifier(ManageAlertsTableViewController.storyboardIdentifier()) as! ManageAlertsTableViewController
        self.manageAlertsVC.wellboreDetailViewController = self
        self.manageAlertsVC.user = self.currentUser
        self.manageAlertsVC.wellbore = self.currentWellbore
        //self.alertInboxTableViewController = storyboard.instantiateViewControllerWithIdentifier(AlertInboxTableViewController.storyboardIdentifier()) as! AlertInboxTableViewController
        //self.alertInboxTableViewController.wellboreDetailViewController = self
        
        // Set them to the segmented control view controllers array,
        // so we can switch between them
        self.segmentedControlViewControllers = [self.dashboardViewController, self.manageAlertsVC]
    }
    
    func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
        if view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        } else {
            for subview in view.subviews {
                var imageView = self.findHairlineImageViewUnder(subview as! UIView)
                if imageView != nil {
                    return imageView
                }
            }
            return nil
        }
    }
    
    private func setupView() {
        self.title = currentWellbore.name
        // self.setupRightBarButtonItem()
        
        self.setViewControllers()
        
        if let mainNavigationController = self.navigationController {
            mainNavigationController.navigationBar.hidden = false
            self.navBarHairlineImageView = self.findHairlineImageViewUnder(mainNavigationController.navigationBar)
            // Create a segmented control inside a toolbar
            let navigationBarHeight = mainNavigationController.navigationBar.frame.size.height
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            self.toolbarYCoord = navigationBarHeight + statusBarHeight
            let toolbarFrame = CGRectMake(0, toolbarYCoord, self.view.frame.size.width, self.toolbarHeight)
            self.segmentedControlToolbar = SegmentControlToolbar(
                frame: toolbarFrame,
                items: segmentedControlItems,
                delegate: self,
                action: Selector("segmentedControlAction:"))
            
            let dashboardNameRect = CGRectMake(0, toolbarYCoord + self.toolbarHeight, self.view.frame.size.width, self.dashboardNameViewHeight)
            let dashboardNameLabelRect = CGRectMake(0, 0, self.view.frame.size.width, self.dashboardNameViewHeight)
            let newDashboardNameView = UIView(frame: dashboardNameRect)
            let newDashboardNameLabel = UILabel(frame: dashboardNameLabelRect)
            newDashboardNameLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
            
            if let dashboard = self.dashboardViewController.currentDashboard {
                newDashboardNameLabel.text = dashboard.name
            } else {
                newDashboardNameLabel.text = "No Dashboard Selected"
            }
            newDashboardNameLabel.textColor = UIColor.whiteColor()
            newDashboardNameLabel.textAlignment = NSTextAlignment.Center
            self.dashboardNameLabel = newDashboardNameLabel
            newDashboardNameView.addSubview(self.dashboardNameLabel)
            newDashboardNameView.backgroundColor = UIColor(red: 0.224, green: 0.224, blue: 0.224, alpha: 1.0)
            self.dashboardNameView = newDashboardNameView
            // Create a new Navigation Controller right below the toolbar
            // that is the height of the screen
            self.segmentNavigationController = UINavigationController()
            self.segmentNavigationController.navigationBarHidden = true
            let navigationControllerFrame = CGRectMake(
                0, toolbarYCoord,
                self.view.frame.size.width,
                self.view.frame.size.height - self.toolbarHeight - toolbarYCoord)
            self.segmentNavigationController.view.frame = navigationControllerFrame
            
            
            // Create a Container View right below the
            // toolbar that is the height of the screen
            let containerViewFrame = CGRectMake(
                0, self.toolbarHeight + self.dashboardNameViewHeight,
                self.view.frame.size.width,
                self.view.frame.size.height - self.toolbarHeight - toolbarYCoord)
            self.containerView = UIView(frame: containerViewFrame)

            // Add the navigation controller to the container view
            self.containerView.addSubview(self.segmentNavigationController.view)
            
            // Add the Toolbar and Container View
            self.view.addSubview(self.containerView)
            self.view.addSubview(self.segmentedControlToolbar)
            self.view.addSubview(self.dashboardNameView)

        }

        self.selectedSegmentIndex = 0
        let incomingViewController = self.segmentedControlViewControllers[0] as UIViewController
        self.segmentNavigationController.setViewControllers([incomingViewController], animated: false)
        if let image = UIImage(named: "settings_line.png") {
            let imageSize = CGSizeMake(30, 30)
            let settingsImage = imageWithImage(image, scaledToSize: imageSize)
            let button = UIBarButtonItem(image: settingsImage, style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemTapped:")
            button.tintColor = UIColor(red: 0.490, green: 0.733, blue: 0.910, alpha: 1.0)
            self.rightBarButtonItem = button
            self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: true)

        } else {
            let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "rightBarButtonItemTapped:")
            button.tintColor = UIColor(red: 0.490, green: 0.733, blue: 0.910, alpha: 1.0)
            self.rightBarButtonItem = button
            self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: true)

            
        }
    }
    
    func segmentedControlAction(sender: UISegmentedControl) {
        // Get the tapped index
        let index = sender.selectedSegmentIndex
        println("Sender selected: \(index)")
        self.selectedSegmentIndex = index
        
        // Ge the new view controller
        let incomingViewController = self.segmentedControlViewControllers[index] as UIViewController
        
        // Tell the navigation controller to set all of its view controllers
        // to only the incoming view controller
        
        // TODO: Hide instead of emptying string
        if index == self.alertsIndex {
            self.updateCurrentDashboardLabelWithString("")
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarButtonItemTapped:")
            addButton.tintColor = UIColor(red: 0.490, green: 0.733, blue: 0.910, alpha: 1.0)

            self.rightBarButtonItem = addButton
            self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: true)

        } else if index == self.dashboardIndex {
            if let dashboard = self.dashboardViewController.currentDashboard {
                self.updateCurrentDashboardLabelWithString(dashboard.name)
            }
            
            if let image = UIImage(named: "settings_line.png") {
                let imageSize = CGSizeMake(30, 30)
                let settingsImage = imageWithImage(image, scaledToSize: imageSize)
                let button = UIBarButtonItem(image: settingsImage, style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemTapped:")
                button.tintColor = UIColor(red: 0.490, green: 0.733, blue: 0.910, alpha: 1.0)

                self.rightBarButtonItem = button
                self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: true)

            } else {
                let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "rightBarButtonItemTapped:")
                button.tintColor = UIColor(red: 0.490, green: 0.733, blue: 0.910, alpha: 1.0)

                self.rightBarButtonItem = button
                self.navigationItem.setRightBarButtonItem(self.rightBarButtonItem, animated: true)

                
            }
        }
        /*
        switch index {
        case self.dashboardIndex:
            // Add the dashboard name view
            self.view.addSubview(self.dashboardNameView)
            
            // Make the container view smaller
            let containerViewFrame = CGRectMake(
                0, self.toolbarHeight + self.dashboardNameViewHeight,
                self.view.frame.size.width,
                self.view.frame.size.height - self.toolbarHeight - toolbarYCoord)
            self.containerView = UIView(frame: containerViewFrame)
            
        case self.alertsIndex:
            // Take away the dashboard name
            self.dashboardNameView.removeFromSuperview()
            
            // Set the container view to be bigger,
            // since there is no dashboard name anymore
            let containerViewFrame = CGRectMake(
                0, self.toolbarHeight,
                self.view.frame.size.width,
                self.view.frame.size.height - self.toolbarHeight - toolbarYCoord)
            self.containerView = UIView(frame: containerViewFrame)
            
        default: break
        }
        */
        self.segmentNavigationController.setViewControllers([incomingViewController], animated: false)
        
       
    }
    
    func rightBarButtonItemTapped(sender: AnyObject) {
        switch self.selectedSegmentIndex {
        case dashboardIndex:
            manageDashboardsBarButtonTapped(sender)
        case alertsIndex:
            manageAlertsBarButtonTapped(sender)
            // addAlertBarButtonTapped(sender)
        default: println("Unknown segment index.")
        }
    }
    
    func showAlertWithMessage(message: String) {
        var alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Shows the user the Manage Alerts view.
    func manageAlertsBarButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let destinationNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.storyboardIdentifier()) as! AddEditAlertNavigationController
        let destination = destinationNavigationController.viewControllers[0] as! AddEditAlertTableViewController
        destination.delegate = self.manageAlertsVC
        destination.wellbore = self.currentWellbore
        destination.currentUser = self.currentUser
        
        self.presentViewController(destinationNavigationController, animated: true, completion: nil)
    }
    
    func manageDashboardsBarButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let manageDashboardsNavigationController = storyboard.instantiateViewControllerWithIdentifier(
            ManageDashboardsNavigationController.storyboardIdentifier()) as! ManageDashboardsNavigationController
        let manageDashboardsTableViewController = manageDashboardsNavigationController.viewControllers[0] as! ManageDashboardsTableViewController

        manageDashboardsTableViewController.wellboreDetailViewController = self
        manageDashboardsTableViewController.currentDashboard = self.dashboardViewController.currentDashboard
        manageDashboardsTableViewController.user = self.currentUser
        manageDashboardsTableViewController.wellbore = self.currentWellbore
        
        self.presentViewController(manageDashboardsNavigationController, animated: true, completion: nil)
    }
    
    private func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
    
}