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
    var segmentedControl: UISegmentedControl!
    var segmentViewControllers: [UIViewController]!
    var segmentNavigationController: UINavigationController!
    
    var currentWellbore: Wellbore!
    var toolbarHeight: CGFloat = 0
    var topBarHeight: CGFloat = 0
    // Switch views
    var containerView: UIView!
    
    // Hiding the navigation bar line
    var navBarHairlineImageView: UIImageView!
    
    // Segmented Control
    let segmentedControlItems = ["Visuals", "Alerts"]
    var selectedSegmentIndex = 0
    let visualsIndex = 0
    let alertsIndex = 1
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    var currentUser: User!
    
    override func viewDidLoad() {
        setupView()
        super.viewDidLoad()
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
    
    
    private func setupView() {
        self.title = currentWellbore.name
        
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
            let parameterAlertsTableViewController = storyboard.instantiateViewControllerWithIdentifier("ParameterAlertsTableViewController") as ParameterAlertsTableViewController
            let viewControllers = [visualsViewController, parameterAlertsTableViewController]
            visualsViewController.wellboreDetailViewController = self
            parameterAlertsTableViewController.wellboreDetailViewController = self
            
            self.segmentViewControllers = [visualsViewController, parameterAlertsTableViewController]
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
            addAlertBarButtonTapped(sender)
        default: println("Unknown segment index.")
        }
    }
    
    func addAlertBarButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddParameterAlertNavigationController.getStoryboardIdentifier()) as AddParameterAlertNavigationController
        self.presentViewController(addAlertNavigationController, animated: true, completion: nil)
    }
    
    func editVisualsBarButtonTapped(sender: AnyObject) {
        
    }
    
    
    func segmentedControlAction(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.selectedSegmentIndex = index
        let incomingViewController = self.segmentViewControllers[index] as UIViewController
        self.segmentNavigationController.setViewControllers([incomingViewController], animated: false)
        
        if let navigationController = self.navigationController {
            switch index {
            case visualsIndex:
                rightBarButtonItem.title = "Edit"
            case alertsIndex:
                rightBarButtonItem.title = "Add"
            default: println("Unknown segment index.")
            }
        }
    }
    
}