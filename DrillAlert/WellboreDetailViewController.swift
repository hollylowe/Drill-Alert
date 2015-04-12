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
    var toolbarHeight: CGFloat = 0
    var topBarHeight: CGFloat = 0
    var navBarHairlineImageView: UIImageView!
    
    // Segmented Control
    var segmentedControl: UISegmentedControl!
    let segmentedControlItems = ["Visuals", "Alerts"]
    var segmentViewControllers: [UIViewController]!
    var segmentNavigationController: UINavigationController!
    var containerView: UIView!

    var selectedSegmentIndex = 0
    let visualsIndex = 0
    let alertsIndex = 1
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
    }
    
    private func setupRightBarButtonItem() {
        let imageSize = CGSizeMake(30, 30)
        self.rightBarButtonItem.title = ""

        if let manageDefaultIcon = UIImage(named: "settings_line.png") {
            rightBarButtonItem.image = imageWithImage(manageDefaultIcon, scaledToSize: imageSize)
        }
    }
    
    private func setupView() {
        self.title = currentWellbore.name
        setupRightBarButtonItem()
        
        if let mainNavigationController = self.navigationController {
            mainNavigationController.navigationBar.hidden = false
            
            self.toolbarHeight = 39.0
            let yCoord = mainNavigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            let toolbarFrame = CGRectMake(0, yCoord, self.view.frame.size.width, toolbarHeight)
            // Set up Toolbar
            let toolbar = SegmentControlToolbar(
                frame: toolbarFrame,
                items: segmentedControlItems,
                delegate: self,
                action: Selector("segmentedControlAction:"))
            
            let segmentedControlNavigationController = UINavigationController()
            segmentedControlNavigationController.navigationBarHidden = true
            
            
            // Set up the Visuals view controller,
            // which is inside a container on this view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let visualsViewController = storyboard.instantiateViewControllerWithIdentifier("VisualsViewController") as! VisualsViewController
            
            // Set up the Alert Inbox view controller,
            // which is inside a container on this view controller
            
            let alertInboxTableViewController = storyboard.instantiateViewControllerWithIdentifier(AlertInboxTableViewController.storyboardIdentifier()) as! AlertInboxTableViewController
            
            
            let viewControllers = [visualsViewController, alertInboxTableViewController]
            visualsViewController.wellboreDetailViewController = self
            visualsViewController.user = self.currentUser
            alertInboxTableViewController.wellboreDetailViewController = self
            
            self.segmentViewControllers = [visualsViewController, alertInboxTableViewController]
            self.segmentNavigationController = segmentedControlNavigationController
            self.segmentedControlAction(toolbar.segmentedControl)
            
            
            // Container view
            let containerViewFrame = CGRectMake(
                0,
                toolbarHeight,
                self.view.frame.size.width,
                self.view.frame.size.height - toolbarHeight - yCoord)
            let navigationControllerFrame = CGRectMake(0, yCoord, self.view.frame.size.width, self.view.frame.size.height - toolbarHeight - yCoord)
            segmentedControlNavigationController.view.frame = navigationControllerFrame
            
            self.containerView = UIView(frame: containerViewFrame)
            self.containerView.addSubview(segmentedControlNavigationController.view)
            self.topBarHeight = toolbarHeight
            self.view.addSubview(self.containerView)
            self.view.addSubview(toolbar)

        }

    }
    
    @IBAction func rightBarButtonItemTapped(sender: AnyObject) {
        switch self.selectedSegmentIndex {
        case visualsIndex:
            manageViewsBarButtonTapped(sender)
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

        manageAlertsTableViewController.wellboreDetailViewController = self
        manageAlertsTableViewController.currentUser = self.currentUser
        self.presentViewController(manageAlertsNavigationController, animated: true, completion: nil)
    }
    
    func manageViewsBarButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let manageViewsNavigationController = storyboard.instantiateViewControllerWithIdentifier(ManageViewsNavigationController.storyboardIdentifier()) as! ManageViewsNavigationController
        let manageViewsTableViewController = manageViewsNavigationController.viewControllers[0] as! ManageViewsTableViewController

        manageViewsTableViewController.wellboreDetailViewController = self
        self.presentViewController(manageViewsNavigationController, animated: true, completion: nil)
    }

    
    func segmentedControlAction(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.selectedSegmentIndex = index
        let incomingViewController = self.segmentViewControllers[index] as UIViewController
        self.segmentNavigationController.setViewControllers([incomingViewController], animated: false)
        
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
            navBarHairlineImageView = self.findHairlineImageViewUnder(navigationController.navigationBar)
            navBarHairlineImageView.hidden = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navBarHairlineImageView.hidden = false
    }
}