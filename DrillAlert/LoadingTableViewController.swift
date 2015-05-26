//
//  LoadingTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/29/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

protocol LoadingTableViewControllerDataSource {
    // Syncrhounous loading operation
    func dataLoadOperation()
    func shouldShowNoDataMessage() -> Bool
    func noDataMessage() -> String
}

class LoadingTableViewController: UITableViewController {
    var dataSource: LoadingTableViewControllerDataSource!
    
    let indicatorWidth: CGFloat = 20
    let indicatorHeight: CGFloat = 20
    var noDataLabelOffset: CGFloat = 0
    
    var loadingData = true
    var loadError = false

    // TODO: Remove, for debugging only
    var shouldLoadFromNetwork = true
    
    override func viewDidLoad() {
        self.tableView.separatorColor = UIColor.blackColor()

        self.loadData()
        super.viewDidLoad()
    }
    
    func loadData() {
        loadError = false
        loadingData = false
        
        if shouldLoadFromNetwork {
            loadError = false
            loadingData = true
            self.tableView.reloadData()
            
            // TODO: This will need to change if we add a way to refresh this page, which we probably will.
            // Instead, we could use the NSURLConnection asynchrounous call. This is because users could
            // refresh the page faster than this call could load it, resulting in multiple threads doing
            // the same operation and messing up the table view.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.dataSource.dataLoadOperation()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadingData = false
                    self.tableView.reloadData()
                })
            })
            
        } else {
            self.tableView.reloadData()
        }
    }
}

extension LoadingTableViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 1
        
        if self.loadingData {
            numberOfSections = 0
            // Display loading indicator
            let backgroundView = UIView(frame: CGRectMake(0, 0,
                self.view.bounds.size.width,
                self.view.bounds.size.height))
            
            let loadingIndicatorFrame = CGRectMake(
                (self.view.bounds.size.width - self.indicatorWidth) / 2,
                (self.view.bounds.size.height - self.indicatorHeight) / 2,
                self.indicatorWidth,
                self.indicatorHeight)
            
            let loadingIndicator = UIActivityIndicatorView(frame: loadingIndicatorFrame)
            
            loadingIndicator.color = UIColor.grayColor()
            loadingIndicator.startAnimating()
            backgroundView.addSubview(loadingIndicator)
            
            self.tableView.backgroundView = backgroundView
            
        } else if self.dataSource.shouldShowNoDataMessage() {
            // Show no alerts message
            numberOfSections = 0
            
            let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
            var noDataLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - noDataLabelOffset))
            noDataLabel.text = self.dataSource.noDataMessage()
            noDataLabel.textColor = textColor
            noDataLabel.numberOfLines = 0
            noDataLabel.textAlignment = .Center
            noDataLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
            noDataLabel.sizeToFit()
            
            self.tableView.backgroundView = noDataLabel
            
        } else {
            self.tableView.backgroundView = nil
        }
        
        return numberOfSections
    }
}