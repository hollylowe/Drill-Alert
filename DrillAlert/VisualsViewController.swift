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
    
    // These are all of a user's WellboreViews
    var wellboreViews = Array<WellboreView>()
    
    // This will be the user's currently selected WellboreView.
    // If they haven't selected one (or the backend doesn't support
    // saving it yet), then this will just be set to the first 
    // view that is in the wellboreViews array.
    var currentWellboreView: WellboreView?
    
    // TODO: Remove this, for debuggin only
    var shouldLoadFromNetwork = true
    
    func reloadVisuals() {
        
    }
    
    override func viewDidLoad() {
        // Get the visuals this user has saved 
        if shouldLoadFromNetwork {
            let (userWellboreViews, error) = WellboreView.getWellboreViewsForUser(self.user)
            if error == nil {
                // TODO: Do something here to set the currentWellboreView
                // to what the user has saved.
                self.wellboreViews = userWellboreViews
                if self.wellboreViews.count > 0 {
                    self.currentWellboreView = self.wellboreViews[0]
                    if let wellboreView = self.currentWellboreView {
                        if wellboreView.panels.count > 1 {
                            wellboreView.panels[0].shouldShowDemoPlot = true
                        }
                    }
                    self.reloadVisuals()
                }
                
            } else {
                if let message = error {
                    wellboreDetailViewController.showAlertWithMessage(message)
                }
            }
            
            super.viewDidLoad()
        } else {
            self.wellboreViews = WellboreView.getFakeWellboreViews()
            if self.wellboreViews.count > 0 {
                self.currentWellboreView = self.wellboreViews[0]
                self.reloadVisuals()
            }
        }
        
        
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, wellboreDetailViewController.topBarHeight)
        if let storyboard = self.storyboard {
            self.pageViewController = storyboard.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
            self.pageViewController.dataSource = self
            
            let startViewController = self.viewControllerAtIndex(0)!
            let viewControllers = [startViewController]
            self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)

            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.addChildViewController(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: "rightBarButtonItemTapped:")
    }
    
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let addEditAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.getStoryboardIdentifier()) as! AddEditAlertNavigationController
        let addEditAlertViewController = addEditAlertNavigationController.viewControllers[0] as! AddEditAlertTableViewController
        //addParameterAlertViewController.delegate = self
        self.presentViewController(addEditAlertNavigationController, animated: true, completion: nil)
    }

    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        var result: UIViewController?
        if let wellboreView = self.currentWellboreView {
            let numberOfPanels = wellboreView.panels.count
            
            if numberOfPanels  == 0 || index >= numberOfPanels {
                // TODO: Return something that says "no panels, add one"
                return nil
            } else if let storyboard = self.storyboard {
                let panelViewController = storyboard.instantiateViewControllerWithIdentifier(VisualViewController.getStoryboardIdentifier()) as! VisualViewController
                panelViewController.pageIndex = index
                let panel = wellboreView.panels[index]
                // Create the panel with each visualization
                panelViewController.panel = panel
                result = panelViewController
            }
        }
        
        return result
    }
}

extension VisualsViewController: UIPageViewControllerDataSource {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        var numberOfPanels = 0
        if let wellboreView = self.currentWellboreView {
            numberOfPanels = wellboreView.panels.count
        }
        return numberOfPanels
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! VisualViewController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index = index - 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! VisualViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index = index + 1
        if let wellboreView = self.currentWellboreView {
            if index == wellboreView.panels.count {
                return nil
            }
        }
        
        
        return self.viewControllerAtIndex(index)
    }
}