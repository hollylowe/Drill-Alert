//
//  AlertsInboxTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 1/19/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertInboxTableViewController: UITableViewController {
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    
    let criticalSection = 0
    let warningSection = 1
    let informationSection = 2
    let readSection = 3
    
    var readItems: [AlertHistoryItem]!
    var warningItems: [AlertHistoryItem]!
    var criticalItems: [AlertHistoryItem]!
    var informationItems: [AlertHistoryItem]!
    
    var shouldLoadFromNetwork = true
    var loadingIndicator: UIActivityIndicatorView?
    var loadingData = true
    var loadError = false
    
    
    override func viewDidLoad() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        //self.tableView.addSubview(self.refreshControl!)
        
        self.loadData()
        
        super.viewDidLoad()
    }
    
    func refresh(sender:AnyObject)
    {
        self.reloadAlertHistory()
        self.refreshControl!.endRefreshing()
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // Let the app delegate know that we are on this view
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.alertInboxTableViewController = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.alertInboxTableViewController = nil
        super.viewDidDisappear(animated)
    }
    
    func reloadAlertHistory() {
        var (alertHistoryItems, optionalError) = AlertHistoryItem.getAlertsHistory()
        
        if let error = optionalError {
            let alertController = UIAlertController(
                title: "Error",
                message: "Unable to load Alert History.",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.criticalItems = Array<AlertHistoryItem>()
            self.warningItems = Array<AlertHistoryItem>()
            self.informationItems = Array<AlertHistoryItem>()
            self.readItems = Array<AlertHistoryItem>()
            
            for alertHistoryItem in alertHistoryItems {
                if let acknowledged = alertHistoryItem.acknowledged {
                    if acknowledged {
                        readItems.append(alertHistoryItem)
                    } else {
                        if let priority = alertHistoryItem.priority {
                            switch priority {
                            case .Critical:
                                criticalItems.append(alertHistoryItem)
                            case .Warning:
                                warningItems.append(alertHistoryItem)
                            case .Information:
                                informationItems.append(alertHistoryItem)
                            default: break
                            }
                        }
                        
                    }
                }
            }
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
        return "AlertInboxTableViewController"
    }
    
}

extension AlertInboxTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                AlertInboxCell.cellIdentifier()) as! AlertInboxCell
            var alertHistoryItem: AlertHistoryItem!
            
            switch indexPath.section {
            case criticalSection:
                alertHistoryItem = criticalItems[indexPath.row]
            case warningSection:
                alertHistoryItem = warningItems[indexPath.row]
            case informationSection:
                alertHistoryItem = informationItems[indexPath.row]
            case readSection:
                alertHistoryItem = readItems[indexPath.row]
            default: alertHistoryItem = nil
            }
            
            cell.setupWithAlertHistoryItem(alertHistoryItem)
            
            return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 4
       
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
            
        } else if criticalItems.count == 0 &&
            warningItems.count == 0 &&
            informationItems.count == 0 &&
            readItems.count == 0 {
            // Show no alert notifications message
            numberOfSections = 0

            let toolbarHeight: CGFloat = 39.0
            let textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
            var noAlertNotificationsLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            noAlertNotificationsLabel.text = "No Alert Notifications"
            noAlertNotificationsLabel.textColor = textColor
            noAlertNotificationsLabel.numberOfLines = 0
            noAlertNotificationsLabel.textAlignment = .Center
            noAlertNotificationsLabel.font = UIFont(name: "HelveticaNeue", size: 26.0)
            noAlertNotificationsLabel.sizeToFit()
            
            self.tableView.backgroundView = noAlertNotificationsLabel
            self.tableView.separatorStyle = .None
            
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .SingleLine
        }
        
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            var numberOfRows = 0
            
            switch section {
            case criticalSection:
                numberOfRows = criticalItems.count
            case warningSection:
                numberOfRows = warningItems.count
            case informationSection:
                numberOfRows = informationItems.count
            case readSection:
                numberOfRows = readItems.count
            default:
                numberOfRows = 0
            }
            
            return numberOfRows
    }
    
    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
            var title = "NA"
            
            switch section {
            case criticalSection:
                title = "Critical"
            case warningSection:
                title = "Warning"
            case informationSection:
                title = "Information"
            case readSection:
                title = "Read"
            default:
                title = "None"
            }
            
            return title
    }
    
}

extension AlertInboxTableViewController: UITableViewDelegate {
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
