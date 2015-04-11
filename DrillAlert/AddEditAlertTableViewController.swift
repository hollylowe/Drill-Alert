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
    var currentUser: User!
    
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
        
        // Dismiss keyboard on anywhere tap
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapRecognizer)
        
        super.viewDidLoad()
    }
    
    func dismissKeyboard() {
        alertValueTextField.resignFirstResponder()
    }
    
    func setAlertTypeLabelTextWithAlertType(alertType: AlertType) {
        self.alertTypeLabel.text = alertType.name
    }
    
    func setupViewWithAlert(alert: Alert) {
        // Set the alert type and value
        if let alertType = alert.getAlertType() {
            self.setAlertTypeLabelTextWithAlertType(alertType)
            self.selectedAlertType = alertType
        }
        
        self.alertValueTextField.text = "\(alert.value)"
        
        // Set the alert when cell
        if alert.alertOnRise.boolValue {
            self.alertOnRiseCell.accessoryType = .Checkmark
            self.alertOnFallCell.accessoryType = .None
        } else {
            self.alertOnRiseCell.accessoryType = .None
            self.alertOnFallCell.accessoryType = .Checkmark
        }
        
        // Set the alert priority cell
        if let priority = alert.getAlertPriority() {
            switch priority {
            case .Critical: alertCriticalPriorityCell.accessoryType = .Checkmark
            case .Warning:  alertWarningPriorityCell.accessoryType = .Checkmark
            case .Information: alertInformationPriorityCell.accessoryType = .Checkmark
            }
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
        
    }
    
    func saveEditedAlert() {
        var alertMessage: String?
        
        if let newAlertType = selectedAlertType {
            if let newValueText = alertValueTextField.text {
                if let newValue = newValueText.toInt() {
                    if let newAlertOnRise = self.getAlertOnRiseValue() {
                        if let newAlertPriority = self.getAlertPriorityValue() {
                            // Edit an Alert
                            
                            
                            if let newAlert = alertToEdit {
                                newAlert.setAlertType(newAlertType)
                                newAlert.value = newValue
                                newAlert.alertOnRise = newAlertOnRise
                                newAlert.setAlertPriority(newAlertPriority)
                                
                                // Save the alert
                                if newAlert.save() {
                                    self.delegate.updateView()
                                    if let session = self.currentUser.userSession {
                                        session.sendFakeNotificationRequest()
                                        
                                    }
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                    
                                } else {
                                    // TODO: Show save error
                                    alertMessage = "Unable to save alert."
                                }
                            }
                        } else {
                            // User didn't select a priority
                            alertMessage = "Please select a priority."
                        }
                    } else {
                        // User didn't select either rise or fall
                        alertMessage = "Please select the alert on rise value."
                    }
                } else {
                    // Invalid user input
                    alertMessage = "Please enter a valid alert value."
                }
            } else {
                // User didn't enter anything for the value
                alertMessage = "Please enter an alert value."
            }
        } else {
            // User didn't select a alert type
            alertMessage = "Please select a alert type."
        }
        
        if let message = alertMessage {
            let alertController = UIAlertController(
                title: "Drill Alert",
                message: message,
                preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    // Creates a new alert, by saving it (in a way 
    // yet to be determined)
    func createNewAlert() {
        var alertMessage: String?
        
        if let newAlertType = selectedAlertType {
            if let newValueText = alertValueTextField.text {
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                
                if let newValue = numberFormatter.numberFromString(newValueText) {
                    
                    if let newAlertOnRise = self.getAlertOnRiseValue() {
                        if let newPriority = self.getAlertPriorityValue() {
                            // Create a new Alert
                            if let newAlert = Alert.createNewInstance(
                                newValue.floatValue,
                                isActive: true,
                                alertOnRise: newAlertOnRise,
                                type: newAlertType,
                                priority: newPriority) {
                                // Successful save
                                self.delegate.updateView()
                                
                                self.dismissViewControllerAnimated(true, completion: nil)

                            } else {
                                // Show alert that says it didn't work
                                alertMessage = "Unable to save  alert."
                            }
                        } else {
                            // User didn't select a priority
                            alertMessage = "Please select a priority."
                        }
                    } else {
                        // User didn't select either rise or fall
                        alertMessage = "Please select the alert on rise value."
                    }
                } else {
                    // Invalid user input
                    alertMessage = "Please enter a valid alert value."
                }
            } else {
                // User didn't enter anything for the value
                alertMessage = "Please enter an alert value."
            }
        } else {
            // User didn't select a alert type
            alertMessage = "Please select a alert type."
        }
        
        if let message = alertMessage {
            let alertController = UIAlertController(
                title: "Drill Alert",
                message: message,
                preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
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
            let destinationViewController = segue.destinationViewController as! SelectAlertTypeTableViewController
            destinationViewController.delegate = self
        }
    }
}
