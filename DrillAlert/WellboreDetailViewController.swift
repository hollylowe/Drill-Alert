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
        self.rightBarButtonItem.title = "Manage"

        if let manageDefaultIcon = UIImage(named: "settings_line.png") {
            rightBarButtonItem.image = imageWithImage(manageDefaultIcon, scaledToSize: imageSize)
        }
    }
    
    private func setupView() {
        self.title = currentWellbore.name
        setupRightBarButtonItem()
        
        if let mainNavigationController = self.navigationController {
            mainNavigationController.navigationBar.hidden = false
            // Add the segmented control at the (navigation bar height + status bar height) y coordinate
            let navigationBarBottomCoord = mainNavigationController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height
            
            // Set up Toolbar
            let toolbarWidth = self.view.frame.size.width
            self.toolbarHeight = 39.0
            let toolbarRect = CGRectMake(0, navigationBarBottomCoord, toolbarWidth, toolbarHeight)
            let toolbar = UIToolbar(frame: toolbarRect)
            
            
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
            
            
            let segmentedControlNavigationController = UINavigationController()
            segmentedControlNavigationController.navigationBarHidden = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let visualsViewController = storyboard.instantiateViewControllerWithIdentifier("VisualsViewController") as VisualsViewController
            
            let alertInboxTableViewController = storyboard.instantiateViewControllerWithIdentifier(AlertInboxTableViewController.storyboardIdentifier()) as AlertInboxTableViewController
            
            let viewControllers = [visualsViewController, alertInboxTableViewController]
            visualsViewController.wellboreDetailViewController = self
            alertInboxTableViewController.wellboreDetailViewController = self
            
            self.segmentViewControllers = [visualsViewController, alertInboxTableViewController]
            self.segmentNavigationController = segmentedControlNavigationController
            
            segmentedControl = UISegmentedControl(items: segmentedControlItems)
            segmentedControl.frame = segmentedControlRect
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(
                self,
                action: Selector("segmentedControlAction:"),
                forControlEvents: .ValueChanged)

            toolbar.addSubview(segmentedControl)
            toolbar.addBottomBorder()
            
            self.view.addSubview(toolbar)
            self.segmentedControlAction(self.segmentedControl)

            // Container view
            let containerYCoord = navigationBarBottomCoord + toolbarHeight
            let containerViewFrame = CGRectMake(
                0,
                containerYCoord,
                self.view.frame.size.width,
                self.view.frame.size.height - containerYCoord)
            let navigationControllerFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - containerYCoord)
            segmentedControlNavigationController.view.frame = navigationControllerFrame
            
            self.containerView = UIView(frame: containerViewFrame)
            self.containerView.addSubview(segmentedControlNavigationController.view)
            self.topBarHeight = containerYCoord
            self.view.addSubview(self.containerView)
        }

    }
    
    @IBAction func rightBarButtonItemTapped(sender: AnyObject) {
        switch self.selectedSegmentIndex {
        case visualsIndex:
            editVisualsBarButtonTapped(sender)
        case alertsIndex:
            manageAlertsBarButtonTapped(sender)
            // addAlertBarButtonTapped(sender)
        default: println("Unknown segment index.")
        }
    }
    
    // Shows the user the Manage Alerts view.
    func manageAlertsBarButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let manageAlertsNavigationController = storyboard.instantiateViewControllerWithIdentifier(
            ManageAlertsNavigationController.storyboardIdentifier()) as ManageAlertsNavigationController
        let manageAlertsTableViewController = manageAlertsNavigationController.viewControllers[0] as ManageAlertsTableViewController

        manageAlertsTableViewController.wellboreDetailViewController = self
        self.presentViewController(manageAlertsNavigationController, animated: true, completion: nil)
    }
    
    func editVisualsBarButtonTapped(sender: AnyObject) {
        
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
                var imageView = self.findHairlineImageViewUnder(subview as UIView)
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