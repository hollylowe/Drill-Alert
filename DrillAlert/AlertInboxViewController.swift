//
//  AlertsInboxTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 1/19/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertInboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController?
    var navBarHairlineImageView: UIImageView?

    
    let criticalIndex = 0
    let warningIndex = 1
    let informationIndex = 2
    var selectedIndex = 0
    var shouldShowRead = false
    var readCriticalItems = [AlertHistoryItem]()
    var readInformationItems = [AlertHistoryItem]()
    var readWarningItems = [AlertHistoryItem]()
    var warningItems = [AlertHistoryItem]()
    var criticalItems = [AlertHistoryItem]()
    var informationItems = [AlertHistoryItem]()

    
    var toolbarYCoord: CGFloat = 0
    var segmentedControlBadgeToolbar: SegmentControlBadgeToolbar!
    var toolbarHeight: CGFloat = 60.0
    var shouldLoadFromNetwork = true
    var loadingIndicator: UIActivityIndicatorView?
    var loadingData = true
    var loadError = false
    
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
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.blackColor()
        self.tableView.separatorColor = UIColor.blackColor()
        
        if let navigationController = self.navigationController {
            self.navBarHairlineImageView = self.findHairlineImageViewUnder(navigationController.navigationBar)

            let navigationBarHeight = navigationController.navigationBar.frame.size.height
            let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
            self.toolbarYCoord = navigationBarHeight + statusBarHeight
            let toolbarFrame = CGRectMake(0, toolbarYCoord, self.view.frame.size.width, self.toolbarHeight)
            
            let redColor = UIColor(red: 0.988, green: 0.227, blue: 0.114, alpha: 1.0)
            let yellowColor = UIColor(red: 0.992, green: 0.761, blue: 0.114, alpha: 1.0)
            let blueColor = UIColor(red: 0.498, green: 0.737, blue: 0.902, alpha: 1.0)
            
            self.segmentedControlBadgeToolbar = SegmentControlBadgeToolbar(frame: toolbarFrame,
                items: ["Critical", "Warning", "Information"],
                itemColors: [redColor, yellowColor, blueColor],
                delegate: self, action: "segmentedControlTapped:")
            
            self.view.addSubview(segmentedControlBadgeToolbar)
            self.tableView.contentInset = UIEdgeInsets(top: toolbarYCoord + self.toolbarHeight, left: 0, bottom: 0, right: 0)
            
            
        }
        
        self.loadData()
        super.viewDidLoad()
    }
    
    func segmentedControlTapped(sender: UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        self.segmentedControlBadgeToolbar.updateColor()
        self.tableView.reloadData()
    }
    
    func refresh(sender:AnyObject)
    {
        self.loadData()
        // self.refreshControl!.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // Let the app delegate know that we are on this view
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.alertInboxViewController = self
        if let homeTabBarController = self.tabBarController as? HomeTabBarController {
            homeTabBarController.changeTitle("Alerts")
            homeTabBarController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh:")
        }
        if let navLine = self.navBarHairlineImageView {
            navLine.hidden = true
        }
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.alertInboxViewController = nil
        if let navLine = self.navBarHairlineImageView {
            navLine.hidden = false
        }
        super.viewDidDisappear(animated)
    }
    
    func reloadAlertHistory() {
        // var (alertHistoryItems, optionalError) = AlertHistoryItem.getAlertsHistory()
        var alertHistoryItems = AlertHistoryItem.getAlertHistoryFixtureData()
        var optionalError: NSError?
        
        if let error = optionalError {
            let alertController = UIAlertController(
                title: "Error",
                message: "Unable to load Alert History.",
                preferredStyle: UIAlertControllerStyle.Alert)
            println(error)
            let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            
            self.criticalItems.removeAll(keepCapacity: false)
            self.warningItems.removeAll(keepCapacity: false)
            self.informationItems.removeAll(keepCapacity: false)
            
            self.readInformationItems.removeAll(keepCapacity: false)
            self.readWarningItems.removeAll(keepCapacity: false)
            self.readCriticalItems.removeAll(keepCapacity: false)
            
            
            for alertHistoryItem in alertHistoryItems {
                if let acknowledged = alertHistoryItem.acknowledged {
                    if acknowledged {
                        if let priority = alertHistoryItem.priority {
                            switch priority {
                            case .Critical: readCriticalItems.append(alertHistoryItem)
                            case .Warning: readWarningItems.append(alertHistoryItem)
                            case .Information: readInformationItems.append(alertHistoryItem)
                            default: break
                            }
                        }
                    } else {
                        if let priority = alertHistoryItem.priority {
                            switch priority {
                            case .Critical: criticalItems.append(alertHistoryItem)
                            case .Warning: warningItems.append(alertHistoryItem)
                            case .Information: informationItems.append(alertHistoryItem)
                            default: break
                            }
                        }
                        
                    }
                }
            }
            
            self.segmentedControlBadgeToolbar.updateBadgeAtIndex(criticalIndex, toNumber: criticalItems.count)
            self.segmentedControlBadgeToolbar.updateBadgeAtIndex(warningIndex, toNumber: warningItems.count)
            self.segmentedControlBadgeToolbar.updateBadgeAtIndex(informationIndex, toNumber: informationItems.count)
        }
        
    }
    
    func loadData() {
        loadError = false
        loadingData = false
        
        if shouldLoadFromNetwork {
            loadError = false
            loadingData = true
            self.tableView.reloadData()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.reloadAlertHistory()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadingData = false
                    self.tableView.reloadData()
                })
            })
            
        } else {
            self.tableView.reloadData()
        }
        
    }
    
    func recievedRemoteNotification() {
        self.loadData()
        self.tableView.reloadData()
    }
    
    class func storyboardIdentifier() -> String! {
        return "AlertInboxViewController"
    }
    
}

extension AlertInboxViewController: UITableViewDataSource {
    
    func alertHistoryItemCellForIndexPath(indexPath: NSIndexPath, items: [AlertHistoryItem], readItems: [AlertHistoryItem]) -> UITableViewCell {
        var cell: UITableViewCell!
        
        var totalItemCount = items.count
        if self.shouldShowRead {
            totalItemCount = totalItemCount + readItems.count
        }
        
        // If we have read items, and the cell row is the last one in 
        // the table view, we should show the read alerts toggle cell.
        if readItems.count > 0 && indexPath.row == totalItemCount {
            let readToggleCell = tableView.dequeueReusableCellWithIdentifier(AlertInboxReadToggleCell.cellIdentifier()) as! AlertInboxReadToggleCell
            if self.shouldShowRead {
                readToggleCell.readLabel.text = "Hide Read Alerts"
            } else {
                readToggleCell.readLabel.text = "Show Read Alerts"
            }
            
            cell = readToggleCell
        } else {
            // Otherwise, it is just a normal cell showing an item.
            let alertInboxCell = tableView.dequeueReusableCellWithIdentifier(
                AlertInboxCell.cellIdentifier()) as! AlertInboxCell
            var alertHistoryItem: AlertHistoryItem!

            if self.shouldShowRead {
                let itemIndex = indexPath.row
                // The item index is coming from the total, 
                // which is the readItemsCount + itemsCount
                if itemIndex < items.count {
                    alertHistoryItem = items[itemIndex]
                } else {
                    alertHistoryItem = readItems[itemIndex - items.count]
                }
            } else {
                alertHistoryItem = items[indexPath.row]
            }
            alertInboxCell.setupWithAlertHistoryItem(alertHistoryItem)
            cell = alertInboxCell
        }
        
        
        
        
        return cell
    }
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell: UITableViewCell!
            
            switch self.selectedIndex {
            case criticalIndex: cell = alertHistoryItemCellForIndexPath(indexPath, items: criticalItems, readItems: readCriticalItems)
            case warningIndex: cell = alertHistoryItemCellForIndexPath(indexPath, items: warningItems, readItems: readWarningItems)
            case informationIndex: cell = alertHistoryItemCellForIndexPath(indexPath, items: informationItems, readItems: readInformationItems)
            default: break
            }
            return cell
    }
    
    func showNoAlertHistoryItemsView() {
        let toolbarHeight: CGFloat = 39.0
        let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        var noAlertNotificationsLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        noAlertNotificationsLabel.text = "No Notifications"
        noAlertNotificationsLabel.textColor = textColor
        noAlertNotificationsLabel.numberOfLines = 0
        noAlertNotificationsLabel.textAlignment = .Center
        noAlertNotificationsLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
        noAlertNotificationsLabel.sizeToFit()
        
        self.tableView.backgroundView = noAlertNotificationsLabel
        self.tableView.separatorStyle = .None
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 1
       
        if loadingData {
            numberOfSections = 0
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
            switch self.selectedIndex {
            case criticalIndex:
                if self.criticalItems.count == 0 && self.readCriticalItems.count == 0 {
                    numberOfSections = 0
                    self.showNoAlertHistoryItemsView()
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .SingleLine
                }
            case warningIndex:
                if self.warningItems.count == 0 && self.readWarningItems.count == 0 {
                    numberOfSections = 0
                    self.showNoAlertHistoryItemsView()
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .SingleLine
                }
            case informationIndex:
                if self.readInformationItems.count == 0 && self.readInformationItems.count == 0 {
                    numberOfSections = 0
                    self.showNoAlertHistoryItemsView()
                } else {
                    self.tableView.backgroundView = nil
                    self.tableView.separatorStyle = .SingleLine
                }
                
            default: break
            }
        }
        
        return numberOfSections
    }
    
    func numberOfRowsForItems(items: [AlertHistoryItem], readItems: [AlertHistoryItem]) -> Int {
        var numberOfRows = 0
        
        if self.shouldShowRead {
            numberOfRows = items.count + readItems.count
        } else {
            numberOfRows = items.count
        }
        
        if readItems.count > 0 {
            numberOfRows = numberOfRows + 1
            // To show read toggle cell
        }
        
        return numberOfRows
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            var numberOfRows = 0
            
            switch self.selectedIndex {
            case criticalIndex: numberOfRows = numberOfRowsForItems(criticalItems, readItems: readCriticalItems)
            case informationIndex: numberOfRows = numberOfRowsForItems(informationItems, readItems: readInformationItems)
            case warningIndex: numberOfRows = numberOfRowsForItems(warningItems, readItems: readWarningItems)
            default: println("Unknown selected index.")
            }
            
            return numberOfRows
    }
}

extension AlertInboxViewController: UITableViewDelegate {
    
    func didSelectRowForItems(items: [AlertHistoryItem], readItems: [AlertHistoryItem], indexPath: NSIndexPath) {
        var totalItemCount = items.count
        if self.shouldShowRead {
            totalItemCount = totalItemCount + readItems.count
        }
        
        if indexPath.row == totalItemCount {
            self.shouldShowRead = !self.shouldShowRead
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch self.selectedIndex {
        case criticalIndex: didSelectRowForItems(criticalItems, readItems: readCriticalItems, indexPath: indexPath)
        case informationIndex: didSelectRowForItems(informationItems, readItems: readInformationItems, indexPath: indexPath)
        case warningIndex: didSelectRowForItems(warningItems, readItems: readWarningItems, indexPath: indexPath)
        default: println("Unknown selected index.")
        }
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var result: [AnyObject]?
        /*
        if indexPath.section != readSection {
            let markAsReadAction = UITableViewRowAction(style: .Normal, title: "Mark as Read", handler: { (rowAction, indexPath) -> Void in
                /*
                var alertNotification: AlertNotification!
                
                switch indexPath.section {
                case self.criticalSection:
                    alertNotification = self.criticalAlertNotifications[indexPath.row]
                case self.warningSection:
                    alertNotification = self.warningAlertNotifications[indexPath.row]
                case self.informationSection:
                    alertNotification = self.informationAlertNotifications[indexPath.row]
                case self.readSection:
                    alertNotification = self.readAlertNotifications[indexPath.row]
                default: alertNotification = nil
                }
                
                self.tableView.beginUpdates()
                
                alertNotification.markAsRead()
                
                // Update all notifications that 
                // have changed in the tableview
                switch indexPath.section {
                case self.criticalSection:
                    self.criticalAlertNotifications = AlertNotification.fetchAllCriticalAlertNotifications()
                case self.warningSection:
                    self.warningAlertNotifications = AlertNotification.fetchAllWarningAlertNotifications()
                case self.informationSection:
                    self.informationAlertNotifications = AlertNotification.fetchAllInformationAlertNotifications()
                default: break
                }
                self.readAlertNotifications = AlertNotification.fetchAllReadAlertNotifications()

                
                // Remove the marked as read notification
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                
                var newRow = 0
                for readAlertNotification in self.readAlertNotifications {
                    if readAlertNotification.objectID == alertNotification.objectID {
                        break
                    } else {
                        newRow++
                    }
                }
                
                // Insert it at the read table view index path
                let newIndexPath = NSIndexPath(forRow: newRow, inSection: self.readSection)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                
                self.tableView.endUpdates()
                
            })
            
            
            markAsReadAction.backgroundColor = UIColor(red: 0.424, green: 0.675, blue: 0.890, alpha: 1.0)
            
            result = [markAsReadAction]
            */
        } else {
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Delete", handler: { (rowAction, indexPath) -> Void in
                var alertNotification = self.readAlertNotifications[indexPath.row]

                self.tableView.beginUpdates()
                
                // Delete from core data
                alertNotification.delete()
                self.readAlertNotifications = AlertNotification.fetchAllReadAlertNotifications()
                
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                
                
                self.tableView.endUpdates()

            })
            
            let unmarkAsReadAction = UITableViewRowAction(style: .Normal, title: "Unmark as Read", handler: { (rowAction, indexPath) -> Void in
                var alertNotification = self.readAlertNotifications[indexPath.row]
                var insertSection = 0
                var insertRow = 0
                
                self.tableView.beginUpdates()
                
                alertNotification.unmarkAsRead()
                
                // Update all notifications that
                // have changed in the tableview
                if let alertPriority = alertNotification.alert.getAlertPriority() {
                    switch alertPriority {
                    case .Critical:
                        self.criticalAlertNotifications = AlertNotification.fetchAllCriticalAlertNotifications()
                        insertSection = self.criticalSection
                        insertRow = self.criticalAlertNotifications.count - 1
                    case .Warning:
                        self.warningAlertNotifications = AlertNotification.fetchAllWarningAlertNotifications()
                        insertSection = self.warningSection
                        insertRow = self.warningAlertNotifications.count - 1
                    case .Information:
                        self.informationAlertNotifications = AlertNotification.fetchAllInformationAlertNotifications()
                        insertSection = self.informationSection
                        insertRow = self.informationAlertNotifications.count - 1
                    default: break
                    }
                }
                
                self.readAlertNotifications = AlertNotification.fetchAllReadAlertNotifications()
                
                // Remove the unmarked as read notification
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                // Insert it at the priority table view index path
                let newIndexPath = NSIndexPath(forRow: insertRow, inSection: insertSection)
                self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                
                self.tableView.endUpdates()
                
            })
            
            
            unmarkAsReadAction.backgroundColor = UIColor(red: 0.424, green: 0.675, blue: 0.890, alpha: 1.0)
            deleteAction.backgroundColor = UIColor.redColor()
            
            result = [unmarkAsReadAction, deleteAction]
        }
        
        */
        return result
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
