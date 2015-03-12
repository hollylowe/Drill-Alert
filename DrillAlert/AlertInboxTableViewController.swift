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
    
    var criticalAlertNotifications: [AlertNotification]!
    var warningAlertNotifications: [AlertNotification]!
    var informationAlertNotifications: [AlertNotification]!
    var readAlertNotifications: [AlertNotification]!
    
    override func viewDidLoad() {
        criticalAlertNotifications = AlertNotification.fetchAllCriticalAlertNotifications()
        warningAlertNotifications = AlertNotification.fetchAllWarningAlertNotifications()
        informationAlertNotifications = AlertNotification.fetchAllInformationAlertNotifications()
        readAlertNotifications = AlertNotification.fetchAllReadAlertNotifications()
        
        // Let the app delegate know that we are on this view
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.alertInboxTableViewController = self
        
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.alertInboxTableViewController = nil
        super.viewDidDisappear(animated)
    }
    
    func recievedRemoteNotification() {
        criticalAlertNotifications = AlertNotification.fetchAllCriticalAlertNotifications()
        warningAlertNotifications = AlertNotification.fetchAllWarningAlertNotifications()
        informationAlertNotifications = AlertNotification.fetchAllInformationAlertNotifications()
        readAlertNotifications = AlertNotification.fetchAllReadAlertNotifications()
        
        self.tableView.reloadData()
    }
    
    class func storyboardIdentifier() -> String! {
        return "AlertInboxTableViewController"
    }
    /*
    func getCriticalSection() -> Int {
        return self.getWarningSection() - 1
    }
    
    func getWarningSection() -> Int {
        return self.getInformationSection() - 1
    }
    
    func getInformationSection() -> Int {
        return self.getReadSection() - 1
    }
    
    func getReadSection() -> Int {
        var section = 0
        
        // The read section is always the last section
        if criticalAlertNotifications.count > 0 {
            section++
        }
        
        if warningAlertNotifications.count > 0 {
            section++
        }
        
        if informationAlertNotifications.count > 0 {
            section++
        }
        
        return section
    }
    */
}

extension AlertInboxTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(
                AlertInboxCell.cellIdentifier()) as AlertInboxCell
            var alertNotification: AlertNotification!
            
            
            switch indexPath.section {
            case criticalSection:
                alertNotification = criticalAlertNotifications[indexPath.row]
            case warningSection:
                alertNotification = warningAlertNotifications[indexPath.row]
            case informationSection:
                alertNotification = informationAlertNotifications[indexPath.row]
            case readSection:
                alertNotification = readAlertNotifications[indexPath.row]
            default: alertNotification = nil
            }
            
            cell.setupWithAlertNotification(alertNotification)
            
            return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 4
        
        /*
        if criticalAlertNotifications.count > 0 {
            numberOfSections++
        }
        
        if warningAlertNotifications.count > 0 {
            numberOfSections++
        }
        
        if informationAlertNotifications.count > 0 {
            numberOfSections++
        }
        
        if readAlertNotifications.count > 0 {
            numberOfSections++
        }
        */
        
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            var numberOfRows = 0
            
            switch section {
            case criticalSection:
                numberOfRows = criticalAlertNotifications.count
            case warningSection:
                numberOfRows = warningAlertNotifications.count
            case informationSection:
                numberOfRows = informationAlertNotifications.count
            case readSection:
                numberOfRows = readAlertNotifications.count
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
        
        if indexPath.section != readSection {
            let markAsReadAction = UITableViewRowAction(style: .Normal, title: "Mark as Read", handler: { (rowAction, indexPath) -> Void in
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
        
        
        return result
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}
