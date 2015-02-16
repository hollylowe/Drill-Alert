//
//  VisualsViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/8/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class VisualsViewController: UIViewController, UIPageViewControllerDataSource {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var user: User!
    
    // Implicit, set in viewDidLoad
    var pageViewController: UIPageViewController!
    
    // Panels 
    var panels = Array<Panel>()
    
    // TODO: Remove this, for debuggin only
    var shouldLoadFromNetwork = false
    
    override func viewDidLoad() {
        
        
        // Get the visuals this user has saved 
        if shouldLoadFromNetwork {
            let (userWellboreViews, error) = WellboreView.getWellboreViewsForUserID(self.user.id)
            if error == nil {
                // There's probably only one wellbore view
                for wellboreView in userWellboreViews {
                    panels = wellboreView.panels
                }
            } else {
                if let message = error {
                    wellboreDetailViewController.showAlertWithMessage(message)
                }
            }
            
            super.viewDidLoad()
        } else {
            for wellboreView in WellboreView.getFakeWellboreViews() {
                panels = wellboreView.panels
            }
        }
        
        
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, wellboreDetailViewController.topBarHeight)
        if let storyboard = self.storyboard {
            self.pageViewController = storyboard.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
            self.pageViewController.dataSource = self
            
            let startViewController = self.viewControllerAtIndex(0)!
            let viewControllers = [startViewController]
            self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)

            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.addChildViewController(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "rightBarButtonItemTapped:")
    }
    
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let addEditAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.getStoryboardIdentifier()) as AddEditAlertNavigationController
        let addEditAlertViewController = addEditAlertNavigationController.viewControllers[0] as AddEditAlertTableViewController
        //addParameterAlertViewController.delegate = self
        self.presentViewController(addEditAlertNavigationController, animated: true, completion: nil)
    }

    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        var result: UIViewController?
        let numberOfPanels = self.panels.count
        
        if numberOfPanels  == 0 || index >= numberOfPanels {
            // TODO: Return something that says "no panels, add one"
            return nil
        } else if let storyboard = self.storyboard {
            let panelViewController = storyboard.instantiateViewControllerWithIdentifier(VisualViewController.getStoryboardIdentifier()) as VisualViewController
            panelViewController.pageIndex = index
            let panel = panels[index]
            // Create the panel with each visualization
            panelViewController.panel = panel
            /*
            // For the demo 
            if index == 1 {
                panelViewController.htmlFileName = "gauge"
            } else if index == 0 {
                panelViewController.htmlFileName = "graph"
            }
            */
            result = panelViewController
        }
        
        return result
    }
}

extension VisualsViewController: UIPageViewControllerDataSource {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.panels.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as VisualViewController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index = index - 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as VisualViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index = index + 1
        if index == self.panels.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
}