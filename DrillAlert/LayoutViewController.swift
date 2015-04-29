//
//  VisualsViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/8/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class LayoutViewController: UIViewController, UIPageViewControllerDataSource {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var user: User!
    
    // Implicit, set in viewDidLoad
    var layoutPageViewController: LayoutPageViewController!
    
    
    // This will be the user's currently selected Layout.
    // If they haven't selected one (or the backend doesn't support
    // saving it yet), then this will just be set to the first 
    // view that is in the layouts array.
    var layouts = Array<Layout>()
    var currentLayout: Layout?
    var wellbore: Wellbore!
    var curves = Array<Curve>()
    
    // TODO: Remove this, for debuggin only
    var shouldLoadFromNetwork = true
    
    var loadingIndicator: UIActivityIndicatorView?
    var loadingData = true
    var loadError = false
    
    override func viewDidLoad() {
        self.loadData()
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.wellboreDetailViewController.topBarHeight)
        if let storyboard = self.storyboard {
            self.layoutPageViewController = storyboard.instantiateViewControllerWithIdentifier(
                LayoutPageViewController.storyboardIdentifier()) as! LayoutPageViewController
            self.layoutPageViewController.dataSource = self
            
            self.layoutPageViewController.view.frame = CGRectMake(
                0,
                0,
                self.view.frame.size.width,
                self.view.frame.size.height)
            
            self.addChildViewController(self.layoutPageViewController)
            self.view.addSubview(self.layoutPageViewController.view)
            self.layoutPageViewController.didMoveToParentViewController(self)
        }
        /*
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: "rightBarButtonItemTapped:")
        */
        
        super.viewDidLoad()
    }
    
    func reloadLayouts() {
        let (newLayouts, error) = Layout.getLayoutsForUser(self.user, andWellbore: self.wellbore)
        
        if error == nil {
            self.layouts = newLayouts
            if self.layouts.count > 0 {
                self.currentLayout = self.layouts[0]
            }
        } else {
            // TODO: Show user error
            println(error)
        }
    }
    
    func updateCurrentLayout(newCurrentLayout: Layout) {
        self.currentLayout = newCurrentLayout
        if let storyboard = self.storyboard {
            // Remove the current page view controller
            self.layoutPageViewController.removeFromParentViewController()
            self.layoutPageViewController.view.removeFromSuperview()
            self.layoutPageViewController = nil
            
            // Create a new one with the new layout
            self.layoutPageViewController = storyboard.instantiateViewControllerWithIdentifier(LayoutPageViewController.storyboardIdentifier()) as! LayoutPageViewController
            self.layoutPageViewController.dataSource = self
            
            self.layoutPageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.addChildViewController(self.layoutPageViewController)
            self.view.addSubview(self.layoutPageViewController.view)
            self.layoutPageViewController.didMoveToParentViewController(self)
            
            if let startViewController = self.viewControllerAtIndex(0) {
                let viewControllers = [startViewController]
                self.layoutPageViewController.setViewControllers(
                    viewControllers,
                    direction: .Forward,
                    animated: true,
                    completion: nil)
            }
        }
        
    }
    
    class func storyboardIdentifier() -> String {
        return "LayoutViewController"
    }
    
    func addLoadingIndicator() {
        let indicatorWidth: CGFloat = 20
        let indicatorHeight: CGFloat = 20
        // Display loading indicator
        
        var backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2))
        self.loadingIndicator = UIActivityIndicatorView(frame: CGRectMake((self.view.bounds.size.width - indicatorWidth) / 2, ((self.view.bounds.size.height / 2) - indicatorHeight) / 2, indicatorWidth, indicatorHeight))
        
        self.loadingIndicator!.color = UIColor.grayColor()
        self.loadingIndicator!.startAnimating()
        backgroundView.addSubview(loadingIndicator!)
        
        self.view.addSubview(backgroundView)
        
    }
    
    func removeLoadingIndicator() {
        self.loadingIndicator!.removeFromSuperview()
        self.loadingIndicator = nil
    }
    
    func loadData() {
        loadError = false
        loadingData = false
        
        // Get the visuals this user has saved
        if shouldLoadFromNetwork {
            loadError = false
            loadingData = true
            
            self.addLoadingIndicator()
            // TODO: This will need to change if we add a way to refresh this page, which we probably will.
            // Instead, we could use the NSURLConnection asynchrounous call. This is because users could
            // refresh the page faster than this call could load it, resulting in multiple threads doing
            // the same operation and messing up the table view.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.reloadLayouts()
                
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
                        self.layoutPageViewController.setViewControllers(
                            viewControllers,
                            direction: .Forward,
                            animated: false,
                            completion: nil)
                    }
                    
                })
            })
            
        } else {
            /*
            self.layouts = WellboreView.getFakeWellboreViews()
            if self.wellboreViews.count > 0 {
                self.currentWellboreView = self.wellboreViews[0]
                // self.reloadVisuals()
            }
            */
        }

        
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
        if let layout = self.currentLayout {
            let numberOfPanels = layout.panels.count
            
            if numberOfPanels == 0 || index >= numberOfPanels {
                // TODO: Return something that says "no panels, add one"
                return nil
            } else if let storyboard = self.storyboard {
                let panelViewController = storyboard.instantiateViewControllerWithIdentifier(PanelViewController.getStoryboardIdentifier()) as! PanelViewController
                panelViewController.pageIndex = index
                let panel = layout.panels[index]
                
                // Create the panel with each visualization
                panelViewController.panel = panel
                result = panelViewController
            }
        }
        
        return result
    }
}

extension LayoutViewController: UIPageViewControllerDataSource {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        var numberOfPanels = 0
        if let layout = self.currentLayout {
            numberOfPanels = layout.panels.count
        }
        return numberOfPanels
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PanelViewController).pageIndex
        println(" before View controller at index: \(index)")

        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index = index - 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PanelViewController).pageIndex
        println("after View controller at index: \(index)")

        if index == NSNotFound {
            return nil
        }
        
        index = index + 1
        if let layout = self.currentLayout {
            if index == layout.panels.count {
                return nil
            }
        }
        
        
        return self.viewControllerAtIndex(index)
    }
}