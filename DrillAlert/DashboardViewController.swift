//
//  VisualsViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/8/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController, UIPageViewControllerDataSource {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var user: User!
    
    // Implicit, set in viewDidLoad
    var dashboardMainPageViewController: DashboardMainPageViewController!
    
    // This will be the user's currently selected dashboard.
    // If they haven't selected one (or the backend doesn't support
    // saving it yet), then this will just be set to the first 
    // dashboard that is in the dashboards array.
    var dashboards = Array<Dashboard>()
    var currentDashboard: Dashboard? {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let dashboard = self.currentDashboard {
                    println("Setting label to: " + dashboard.name)
                    self.wellboreDetailViewController.updateCurrentDashboardLabelWithString(dashboard.name)
                }
            })
        }
    }
    var wellbore: Wellbore!
    var curves = Array<Curve>()
    
    // TODO: Remove this, for debuggin only
    var shouldLoadFromNetwork = true
    
    var loadingIndicator: UIActivityIndicatorView?
    var loadingData = true
    var loadError = false
    
    override func viewDidLoad() {
        self.loadData()
        // self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.wellboreDetailViewController.toolbarHeight)
        if let storyboard = self.storyboard {
            self.dashboardMainPageViewController = storyboard.instantiateViewControllerWithIdentifier(
                DashboardMainPageViewController.storyboardIdentifier()) as! DashboardMainPageViewController
            self.dashboardMainPageViewController.dataSource = self
            self.dashboardMainPageViewController.view.frame = CGRectMake(
                0,
                0,
                self.view.frame.size.width,
                self.view.frame.size.height - self.wellboreDetailViewController.dashboardNameViewHeight)
            
            self.addChildViewController(self.dashboardMainPageViewController)
            self.view.addSubview(self.dashboardMainPageViewController.view)
            self.dashboardMainPageViewController.didMoveToParentViewController(self)
        }
        
        super.viewDidLoad()
    }
    
    func reloadDashboards() {
        let (newDashboards, error) = Dashboard.getDashboardsForUser(self.user, andWellbore: self.wellbore)
        
        if error == nil {
            self.dashboards = newDashboards
            if self.dashboards.count > 0 {
                self.currentDashboard = self.dashboards[0]
            }
        } else {
            // TODO: Show user error
            println(error)
        }
    }
    
    func updateCurrentDashboard(newCurrentDashboard: Dashboard) {
        self.currentDashboard = newCurrentDashboard
        if let storyboard = self.storyboard {
            // Remove the current page view controller
            self.dashboardMainPageViewController.removeFromParentViewController()
            self.dashboardMainPageViewController.view.removeFromSuperview()
            self.dashboardMainPageViewController = nil
            
            // Create a new one with the new layout
            self.dashboardMainPageViewController = storyboard.instantiateViewControllerWithIdentifier(DashboardMainPageViewController.storyboardIdentifier()) as! DashboardMainPageViewController
            self.dashboardMainPageViewController.dataSource = self
            
            self.dashboardMainPageViewController.view.frame = CGRectMake(
                0, 0,
                self.view.frame.size.width,
                self.view.frame.size.height - self.wellboreDetailViewController.dashboardNameViewHeight)
            self.addChildViewController(self.dashboardMainPageViewController)
            
            self.view.addSubview(self.dashboardMainPageViewController.view)
            self.dashboardMainPageViewController.didMoveToParentViewController(self)
            
            if let startViewController = self.viewControllerAtIndex(0) {
                let viewControllers = [startViewController]
                self.dashboardMainPageViewController.setViewControllers(
                    viewControllers,
                    direction: .Forward,
                    animated: true,
                    completion: nil)
            }
        }
        
    }
    
    class func storyboardIdentifier() -> String {
        return "DashboardViewController"
    }
    
    func addLoadingIndicator() {
        let indicatorWidth: CGFloat = 20
        let indicatorHeight: CGFloat = 20
        var backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2))
        let indicatorFrame = CGRectMake(
            (self.view.bounds.size.width - indicatorWidth) / 2,
            ((self.view.bounds.size.height / 2) - indicatorHeight) / 2,
            indicatorWidth,
            indicatorHeight)
        
        let newLoadingIndicator = UIActivityIndicatorView(frame: indicatorFrame)
        newLoadingIndicator.color = UIColor.grayColor()
        newLoadingIndicator.startAnimating()
        self.loadingIndicator = newLoadingIndicator
        backgroundView.addSubview(newLoadingIndicator)
        
        self.view.addSubview(backgroundView)
    }
    
    func removeLoadingIndicator() {
        self.loadingIndicator!.removeFromSuperview()
        self.loadingIndicator = nil
    }
    
    func loadData() {
        loadError = false
        loadingData = false
        
        if shouldLoadFromNetwork {
            loadError = false
            loadingData = true
            
            self.addLoadingIndicator()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.reloadDashboards()
                
                var (newCurves, errorMessage) = self.wellbore.getCurves(self.user)
                
                self.curves = newCurves 
                for curve in self.curves {
                    println(curve.name)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadingData = false
                    self.removeLoadingIndicator()
                    
                    if let startViewController = self.viewControllerAtIndex(0) {
                        let viewControllers = [startViewController]
                        self.dashboardMainPageViewController.setViewControllers(
                            viewControllers,
                            direction: .Forward,
                            animated: false,
                            completion: nil)
                    }
                    
                })
            })
            
        } else {
            // TODO: Load fake data
        }
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addEditAlertNavigationController = storyboard.instantiateViewControllerWithIdentifier(AddEditAlertNavigationController.storyboardIdentifier()) as! AddEditAlertNavigationController
        let addEditAlertViewController = addEditAlertNavigationController.viewControllers[0] as! AddEditAlertTableViewController
        //addParameterAlertViewController.delegate = self
        self.presentViewController(addEditAlertNavigationController, animated: true, completion: nil)
    }

    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        var result: UIViewController?
        if let dashboard = self.currentDashboard {
            let numberOfPages = dashboard.pages.count
            
            if numberOfPages == 0 || index >= numberOfPages {
                // TODO: Return something that says "no panels, add one"
                return nil
            } else if let storyboard = self.storyboard {
                let pageViewController = storyboard.instantiateViewControllerWithIdentifier(PageViewController.getStoryboardIdentifier()) as! PageViewController
                pageViewController.pageIndex = index
                pageViewController.wellbore = self.wellbore
                let page = dashboard.pages[index]
                
                // Create the panel with each visualization
                pageViewController.page = page
                result = pageViewController
            }
        }
        
        return result
    }
}

extension DashboardViewController: UIPageViewControllerDataSource {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        var numberOfPages = 0
        if let dashboard = self.currentDashboard {
            numberOfPages = dashboard.pages.count
        }
        return numberOfPages
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let pageViewController = viewController as? PageViewController {
            var index = pageViewController.pageIndex
            if index == 0 || index == NSNotFound {
                return nil
            }
            
            index = index - 1
            return self.viewControllerAtIndex(index)
        } else {
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageViewController).pageIndex

        if index == NSNotFound {
            return nil
        }
        
        index = index + 1
        if let dashboard = self.currentDashboard {
            if index == dashboard.pages.count {
                return nil
            }
        }
        
        
        return self.viewControllerAtIndex(index)
    }
}