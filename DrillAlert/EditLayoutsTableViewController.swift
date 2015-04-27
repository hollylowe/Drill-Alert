//
//  EditLayoutsTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class EditLayoutsTableViewController: UITableViewController {
    var user: User!
    var wellbore: Wellbore!
    var layouts = Array<Layout>()
    
    var loadError = false
    var loadingData = true
    var shouldLoadFromNetwork = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadData()
        super.viewDidAppear(animated)
    }
    
    func reloadLayouts() {
        let (newLayouts, error) = Layout.getLayoutsForUser(self.user, andWellbore: self.wellbore)
        
        if error == nil {
            self.layouts = newLayouts
        } else {
            // TODO: Show user error
            println(error)
        }
    }
    
    func loadData() {
        self.loadError = false
        self.loadingData = false
        
        if self.shouldLoadFromNetwork {
            self.loadError = false
            self.loadingData = true
            self.tableView.reloadData()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.reloadLayouts()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadingData = false
                    self.tableView.reloadData()
                })
            })
            
        } else {
            // Load fake data
            self.tableView.reloadData()
        }
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddEditLayoutTableViewController.editLayoutSegueIdentifier() {
            if let cell = sender as? UITableViewCell {
                if let indexPath = self.tableView.indexPathForCell(cell) {
                    let destination = segue.destinationViewController as! AddEditLayoutTableViewController
                    destination.layoutToEdit = self.layouts[indexPath.row]
                    destination.user = self.user
                    destination.wellbore = self.wellbore
                }
            }
            
        }
        super.prepareForSegue(segue, sender: sender)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EditLayoutTableViewCell.cellIdentifier()) as! EditLayoutTableViewCell
        let layout = self.layouts[indexPath.row]
        cell.setupWithLayout(layout)
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.layouts.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections = 1
        
        if self.loadingData {
            sections = 0
            let indicatorWidth: CGFloat = 20
            let indicatorHeight: CGFloat = 20
            // Display loading indicator
            var backgroundView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake((self.view.bounds.size.width - indicatorWidth) / 2, (self.view.bounds.size.height - indicatorHeight) / 2, indicatorWidth, indicatorHeight))
            
            loadingIndicator.color = UIColor.grayColor()
            loadingIndicator.startAnimating()
            backgroundView.addSubview(loadingIndicator)
            self.tableView.backgroundView = backgroundView
            self.tableView.separatorStyle = .None
            
        } else {
            
            if self.layouts.count == 0 {
                sections = 0
                
                // Display "No Layouts" message
                let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
                var noLayoutsLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
                if self.loadError {
                    noLayoutsLabel.text = "Network Error"
                } else {
                    noLayoutsLabel.text = "No Layouts"
                }
                
                noLayoutsLabel.textColor = textColor
                noLayoutsLabel.numberOfLines = 0
                noLayoutsLabel.textAlignment = .Center
                noLayoutsLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
                noLayoutsLabel.sizeToFit()
                
                self.tableView.backgroundView = noLayoutsLabel
                self.tableView.separatorStyle = .None
            } else {
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = .SingleLine
            }
            
        }
        
        return sections
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    class func entrySegueIdentifier() -> String! {
        return "EditLayoutsSegueIdentifier"
    }
    
}