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
    
    var pageViewController: UIPageViewController!
    var numVisuals = 4
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storyboard = self.storyboard {
            self.pageViewController = storyboard.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
            self.pageViewController.dataSource = self
            
            let startViewController = self.viewControllerAtIndex(0)!
            let viewControllers = [startViewController]
            self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
            
            let yCoord = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.size.height
            let height = self.view.frame.size.height - yCoord - self.tabBarController!.tabBar.frame.size.height
            self.pageViewController.view.frame = CGRectMake(0, yCoord, self.view.frame.size.width, height)
            self.addChildViewController(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        var result: UIViewController?
        
        if numVisuals == 0 || index >= numVisuals {
            return nil
        } else if let storyboard = self.storyboard {
            let pageContentViewController = storyboard.instantiateViewControllerWithIdentifier("VisualViewController") as VisualViewController
            pageContentViewController.pageIndex = index
            
            result = pageContentViewController
        }
        
        return result
    }
}

extension VisualsViewController: UIPageViewControllerDataSource {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.numVisuals
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
        if index == numVisuals {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
}