//
//  AddParameterAlertTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/30/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditAlertNavigationController: UINavigationController {
    class func getStoryboardIdentifier() -> String! {
        return "AddEditAlertNavigationController"
    }
    
    class func getEntrySegueIdentifier() -> String! {
        return "AddEditAlertSegue"
    }
}

// This is a static UITableViewController that
// manages the adding and editing of Alerts. 
class AddEditAlertTableViewController: UITableViewController {
    
    // Static UI elements on the Add or Edit view
    @IBOutlet weak var alertTypeLabel: UILabel!
    @IBOutlet weak var alertValueTextField: UITextField!
    
    // These Rise / Fall cells will have a checkmark next to them,
    // representing the selected value for this alert.
    // Only one can be selected at a time.
    @IBOutlet weak var alertOnRiseCell: UITableViewCell!
    @IBOutlet weak var alertOnFallCell: UITableViewCell!
    
    // Same for these Priority cells.
    @IBOutlet weak var alertCriticalPriorityCell: UITableViewCell!
    @IBOutlet weak var alertWarningPriorityCell: UITableViewCell!
    @IBOutlet weak var alertInformationPriorityCell: UITableViewCell!
    
    // This is the alert's type, which must be set
    // by the user to create a new alert. It is selected
    // from a seperate view controller (SelectAlertType),
    // and set here upon that view controller's dismissal.
    var selectedAlertType: AlertType?
    
    // This will be set by the previous
    // view controller, Manage Alerts, if a 
    // user has clicked on an Alert's table view cell
    //
    // If this is set, then the UI will change to 
    // represent the user is editing this alert
    var alertToEdit: Alert?
    
    // The previous view controller is the delegate, 
    // and it is always set.
    // If a user adds or edits an alert, the 
    // previous view needs to be refreshed.
    // To do this before the user gets to it, we 
    // refresh the delegate's tableview data before 
    // we dismiss this view.
    var delegate: ManageAlertsTableViewController!
    
    override func viewDidLoad() {
        // We want to change the title 
        // of the page if the user is adding 
        // or editing an alert
        
        if let alert = alertToEdit {
            // Set up the Edit view
            self.title = "Edit Alert"
            self.setupViewWithAlert(alert)
            
        } else {
            // Set up the Add view
            self.title = "Add Alert"
        }
        
        super.viewDidLoad()
    }
    
    func setAlertTypeLabelTextWithAlertType(alertType: AlertType) {
        self.alertTypeLabel.text = alertType.name
    }
    
    func setupViewWithAlert(alert: Alert) {
        // Set the alert type and value
        self.selectedAlertType = alert.type
        self.setAlertTypeLabelTextWithAlertType(alert.type)
        self.alertValueTextField.text = "\(alert.value)"
        
        // Set the alert when cell
        if alert.alertOnRise {
            self.alertOnRiseCell.accessoryType = .Checkmark
            self.alertOnFallCell.accessoryType = .None
        } else {
            self.alertOnRiseCell.accessoryType = .None
            self.alertOnFallCell.accessoryType = .Checkmark
        }
        
        // Set the alert priority cell
        alertCriticalPriorityCell.accessoryType = .None
        alertWarningPriorityCell.accessoryType = .None
        alertInformationPriorityCell.accessoryType = .None
        
        switch alert.priority {
        case .Critical: alertCriticalPriorityCell.accessoryType = .Checkmark
        case .Warning:  alertWarningPriorityCell.accessoryType = .Checkmark
        case .Information: alertInformationPriorityCell.accessoryType = .Checkmark
        }
    }
    
    func getAlertOnRiseValue() -> Bool? {
        var result: Bool?
        
        // Only return a value if the user has selected one
        // of the alert when cells
        if alertOnRiseCell.accessoryType == .Checkmark || alertOnFallCell.accessoryType == .Checkmark {
            result = alertOnRiseCell.accessoryType == .Checkmark
        }
        
        return result
    }
    
    func getAlertPriorityValue() -> AlertPriority? {
        var result: AlertPriority?
        
        if alertCriticalPriorityCell.accessoryType == .Checkmark {
            result = .Critical
        } else if alertWarningPriorityCell.accessoryType == .Checkmark {
            result = .Warning
        } else if alertInformationPriorityCell.accessoryType == .Checkmark {
            result = .Information
        }
        
        return result
    }
    
    @IBAction func leftBarButtonTapped(sender: AnyObject) {
        // Cancel button was tapped, 
        // dismiss the view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func rightBarButtonTapped(sender: AnyObject) {
        if let alert = alertToEdit {
            // TODO: Save the changes made
            // to the alert
            saveEditedAlert()
        } else {
            // TODO: Add a new Alert
            createNewAlert()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveEditedAlert() {
        if let newAlertType = selectedAlertType {
            if let newValueText = alertValueTextField.text {
                if let newValue = newValueText.toInt() {
                    if let newAlertOnRise = self.getAlertOnRiseValue() {
                        if let newPriority = self.getAlertPriorityValue() {
                            // Edit an Alert
                            if let newAlert = alertToEdit {
                                newAlert.type = newAlertType
                                newAlert.value = newValue
                                newAlert.alertOnRise = newAlertOnRise
                                newAlert.priority = newPriority
                                
                                // Save the alert to whatever we're saving them to
                            }
                            
                            // Refrese the previous view, to represent the added alert
                            // TODO: Replace this with some actual model data
                            self.delegate.tableView.reloadData()
                        } else {
                            // User didn't select a priority
                        }
                    } else {
                        // User didn't select either rise or fall
                    }
                } else {
                    // Invalid user input
                }
            } else {
                // User didn't enter anything for the value
            }
        } else {
            // User didn't select a alert type
        }
    }
    
    // Creates a new alert, by saving it (in a way 
    // yet to be determined)
    func createNewAlert() {
        if let newAlertType = selectedAlertType {
            if let newValueText = alertValueTextField.text {
                if let newValue = newValueText.toInt() {
                    if let newAlertOnRise = self.getAlertOnRiseValue() {
                        if let newPriority = self.getAlertPriorityValue() {
                            // Create a new Alert
                            let newAlert = Alert(
                                type: newAlertType,
                                value: newValue,
                                alertOnRise: newAlertOnRise,
                                priority: newPriority
                            )
                            
                            // Refrese the previous view, to represent the added alert
                            // TODO: Replace this with some actual model data
                            
                            self.delegate.alerts.append(newAlert)
                            self.delegate.tableView.reloadData()
                        } else {
                            // User didn't select a priority
                        }
                    } else {
                        // User didn't select either rise or fall
                    }
                } else {
                    // Invalid user input
                }
            } else {
                // User didn't enter anything for the value
            }
        } else {
            // User didn't select a alert type
        }
    }
    
    func pushSelectAlertTypeViewController() {
        self.performSegueWithIdentifier(SelectAlertTypeTableViewController.getEntrySegueIdentifier(), sender: nil)
    }
    
}

extension AddEditAlertTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let selectedCell = tableView.cellForRowAtIndexPath(indexPath) {
            let alertTypeSection = 0
            let alertTypeCellRow = 0
            
            let alertValueSection = 1
            let alertValueCellRow = 0
            
            let alertWhenSection = 2
            let alertOnRiseCellRow = 0
            let alertOnFallCellRow = 1
            
            let alertPrioritySection = 3
            let alertCriticalPriorityCellRow = 0
            let alertWarningPriorityCellRow = 1
            let alertInformationPriorityCellRow = 2
            
            switch indexPath.section {
            case alertWhenSection:
                alertOnFallCell.accessoryType = .None
                alertOnRiseCell.accessoryType = .None
                selectedCell.accessoryType = .Checkmark
            case alertPrioritySection:
                alertCriticalPriorityCell.accessoryType = .None
                alertWarningPriorityCell.accessoryType = .None
                alertInformationPriorityCell.accessoryType = .None
                selectedCell.accessoryType = .Checkmark
            case alertTypeSection:
                pushSelectAlertTypeViewController()
            default: break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectAlertTypeTableViewController.getEntrySegueIdentifier() {
            let destinationViewController = segue.destinationViewController as SelectAlertTypeTableViewController
            destinationViewController.delegate = self
        }
    }
}

/*
class AddAlertTableViewController: UITableViewController {
    
    // Segues
    let selectAlertTypeSegue = "SelectAlertTypeSegue"
    let addOrEditAlertSegue = "AddOrEditAlertSegue"
    
    var alerts = Array<Alert>()
    var selectedType: AlertType?
    var delegate: ManageAlertsTableViewController!
    
    let numberOfSections = 2
    let alertTypeSection = 0
    let alertsSection = 1
    
    class func getStoryboardIdentifier() -> String! {
        return "AddAlertTableViewController"
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        // TODO: remove this stuff and fake notification, purely for the demo
        if let alertType = selectedType {
            
            /*
            let parameterAlert = ParameterAlert(parameter: parameter, alerts: alerts)
            // delegate.addAlertToTableView(parameterAlert)
            
            let alert = alerts[0]
            var noti = UILocalNotification()
            var body = parameter.name
            noti.fireDate = NSDate(timeInterval: 6, sinceDate: NSDate())
            
            if alert.alertWhenRisesToValue {
                body = body + " on Wellbore 1 has reached \(alert.value)."
            } else {
                body = body + " on Wellbore 1 has fallen to \(alert.value)."
            }
            
            noti.alertBody = body
            noti.timeZone = NSTimeZone.defaultTimeZone()
            UIApplication.sharedApplication().scheduleLocalNotification(noti)
            */
            
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == selectAlertTypeSegue {
            let destinationViewController = segue.destinationViewController as SelectAlertTypeTableViewController
            destinationViewController.delegate = self
        } else if segue.identifier == addOrEditAlertSegue {
            let destinationViewController = segue.destinationViewController as UINavigationController
            let addOrEditAlertViewController = destinationViewController.viewControllers[0] as AddOrEditAlertTableViewController
            if sender == nil {
                // Add alert view should be pushed
                addOrEditAlertViewController.delegate = self
                addOrEditAlertViewController.alertToEdit = nil
            } else {
                let alert = sender as Alert
                addOrEditAlertViewController.delegate = self
                addOrEditAlertViewController.alertToEdit = alert
            }
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func pushSelectAlertTypeView() {
        self.performSegueWithIdentifier(selectAlertTypeSegue, sender: self)
    }
    
    func pushAddAlertView() {
        self.performSegueWithIdentifier(addOrEditAlertSegue, sender: nil)
    }
    
    func pushEditAlertViewWithAlert(alert: Alert) {
        self.performSegueWithIdentifier(addOrEditAlertSegue, sender: alert)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
}

extension AddAlertTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case alertTypeSection:
            // Parameter cell selected, push select parameter view
            pushSelectAlertTypeView()
        case alertsSection:
            // Alert cell selected, push edit alert view
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.reuseIdentifier == "NewAlertCell" {
                    pushAddAlertView()
                } else {
                    let alert = alerts[indexPath.row]
                    pushEditAlertViewWithAlert(alert)
                }
            }
            
            
        default: println("Unknown section selected.")
        }
    }
    
}
extension AddAlertTableViewController: UITableViewDataSource {
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
            
        case alertTypeSection:
            cell = tableView.dequeueReusableCellWithIdentifier("ParameterCell") as UITableViewCell
            if let textLabel = cell.textLabel {
                textLabel.text = "Parameter"
            }
            if let detailTextLabel = cell.detailTextLabel {
                if let alertType = selectedType {
                    detailTextLabel.text = alertType.name
                } else {
                    detailTextLabel.text = "None"
                }
            }
            
        case alertsSection:
            // If it is not the last cell
            let alertSectionRow = indexPath.row
            if alerts.count != 0 && alertSectionRow < alerts.count {
                let alert = alerts[alertSectionRow]
                
                cell = tableView.dequeueReusableCellWithIdentifier("AlertCell") as UITableViewCell
                if alert.alertOnRise {
                    if let textLabel = cell.textLabel {
                        textLabel.text = "Rise to \(alert.value), \(alert.priority.rawValue) Priority"
                    }
                } else {
                    if let textLabel = cell.textLabel {
                        textLabel.text = "Falls to \(alert.value), \(alert.priority.rawValue) Priority"
                    }
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("NewAlertCell") as UITableViewCell
                if let textLabel = cell.textLabel {
                    textLabel.text = "New..."
                }
            }
        default:
            println("Unknown section in tableview.")
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result: Int!
        
        switch section {
        case alertTypeSection:
            result = 1
        case alertsSection:
            result = 1 + alerts.count
        default:
            result = 0
        }
        
        return result
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
}

*/