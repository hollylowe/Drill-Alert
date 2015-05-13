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
    var toolbarHeight: CGFloat = 39.0
    var navBarHairlineImageView: UIImageView!
    
    // Segmented Control
    var segmentedControlToolbar: SegmentControlToolbar!
    
    var segmentedControl: UISegmentedControl!
    let segmentedControlItems = ["Dashboard", "Alerts"]
    var segmentedControlViewControllers: [UIViewController]!
    var segmentNavigationController: UINavigationController!
    var containerView: UIView!
    
    // The two main view controllers for the segmented control
    var dashboardViewController: DashboardViewController!
    var alertInboxTableViewController: AlertInboxTableViewController!
    
    var selectedSegmentIndex = 0
    let visualsIndex = 0
    let alertsIndex = 1
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
    }
    
    private func setViewControllers() {
        // Instantiate the Dashboard View Controller
        // and the Alert Inbox View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.dashboardViewController = storyboard.instantiateViewControllerWithIdentifier(DashboardViewController.storyboardIdentifier()) as! DashboardViewController
        self.dashboardViewController.user = self.currentUser
        self.dashboardViewController.wellbore = self.currentWellbore
        self.dashboardViewController.wellboreDetailViewController = self
        
        self.alertInboxTableViewController = storyboard.instantiateViewControllerWithIdentifier(AlertInboxTableViewController.storyboardIdentifier()) as! AlertInboxTableViewController
        self.alertInboxTableViewController.wellboreDetailViewController = self
        
        // Set them to the segmented control view controllers array,
        // so we can switch between them
        self.segmentedControlViewControllers = [self.dashboardViewController, self.alertInboxTableViewController]
    }
    
    private func setupView() {
        self.title = currentWellbore.name
        self.setupRightBarButtonItem()
        self.setViewControllers()
        
        if let mainNavigationController = self.navigationController {
            mainNavigationController.navigationBar.hidden = false
            
            // Create a segmented control inside a toolbar
            let navigationBarHeight = mainNavigationController.navigationBar.frame.size.height
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            let toolbarYCoord = navigationBarHeight + statusBarHeight
            let toolbarFrame = CGRectMake(0, toolbarYCoord, self.view.frame.size.width, self.toolbarHeight)
            self.segmentedControlToolbar = SegmentControlToolbar(
                frame: toolbarFrame,
                items: segmentedControlItems,
                delegate: self,
                action: Selector("segmentedControlAction:"))
            
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
                0, self.toolbarHeight,
                self.view.frame.size.width,
                self.view.frame.size.height - self.toolbarHeight - toolbarYCoord)
            self.containerView = UIView(frame: containerViewFrame)

            // Add the navigation controller to the container view
            self.containerView.addSubview(self.segmentNavigationController.view)
            
            // Add the Toolbar and Container View
            self.view.addSubview(self.containerView)
            self.view.addSubview(self.segmentedControlToolbar)

        }

        // Run the segmented control action once to set it up
        self.segmentedControlAction(self.segmentedControlToolbar.segmentedControl)
    }
    
    func segmentedControlAction(sender: UISegmentedControl) {
        // Get the tapped index
        let index = sender.selectedSegmentIndex
        self.selectedSegmentIndex = index
        
        // Ge the new view controller
        let incomingViewController = self.segmentedControlViewControllers[index] as UIViewController
        
        // Tell the navigation controller to set all of its view controllers
        // to only the incoming view controller
        self.segmentNavigationController.setViewControllers([incomingViewController], animated: true)
    }
    
    
    private func setupRightBarButtonItem() {
        let imageSize = CGSizeMake(30, 30)
        self.rightBarButtonItem.title = ""
        
        if let manageDefaultIcon = UIImage(named: "settings_line.png") {
            rightBarButtonItem.image = imageWithImage(manageDefaultIcon, scaledToSize: imageSize)
        }
    }
    
    @IBAction func rightBarButtonItemTapped(sender: AnyObject) {
        switch self.selectedSegmentIndex {
        case visualsIndex:
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
        let manageAlertsNavigationController = storyboard.instantiateViewControllerWithIdentifier(
            ManageAlertsNavigationController.storyboardIdentifier()) as! ManageAlertsNavigationController
        let manageAlertsTableViewController = manageAlertsNavigationController.viewControllers[0] as! ManageAlertsTableViewController

        manageAlertsTableViewController.user = self.currentUser
        manageAlertsTableViewController.wellbore = self.currentWellbore
        self.presentViewController(manageAlertsNavigationController, animated: true, completion: nil)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding the navigation bar line
        if let navigationController = self.navigationController {
           // navBarHairlineImageView = self.findHairlineImageViewUnder(navigationController.navigationBar)
           // navBarHairlineImageView.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //navBarHairlineImageView.hidden = false
    }
}