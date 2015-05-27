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
    class func storyboardIdentifier() -> String! {
        return "AddEditAlertNavigationController"
    }
    
    class func entrySegueIdentifier() -> String! {
        return "AddEditAlertSegue"
    }
}

// This is a static UITableViewController that
// manages the adding and editing of Alerts. 
class AddEditAlertTableViewController: UITableViewController {
    
    let alertNameSection = 0
    let alertCurveSection = 1
    let alertCurveRow = 0
    
    let alertValueSection = 2
    let alertValueCellRow = 0
    
    let alertWhenSection = 3
    let alertOnRiseCellRow = 0
    let alertOnFallCellRow = 1
    
    let alertPrioritySection = 4
    let alertCriticalPriorityCellRow = 0
    let alertWarningPriorityCellRow = 1
    let alertInformationPriorityCellRow = 2
    
    let alertDebugSection = 5
    let sendAlertNotificationCellRow = 0
    
    @IBOutlet weak var noCurveSelectedLabel: UILabel!
    @IBOutlet weak var curveIVTLabel: UILabel!
    @IBOutlet weak var curveNameLabel: UILabel!
    // Static UI elements on the Add or Edit view
    // @IBOutlet weak var alertTypeLabel: UILabel!
    @IBOutlet weak var alertValueTextField: UITextField!
    @IBOutlet weak var alertNameTextField: UITextField!
    
    
    // These Rise / Fall cells will have a checkmark next to them,
    // representing the selected value for this alert.
    // Only one can be selected at a time.
    @IBOutlet weak var alertOnRiseCell: UITableViewCell!
    @IBOutlet weak var alertOnFallCell: UITableViewCell!
    
    // Same for these Priority cells.
    @IBOutlet weak var alertCriticalPriorityCell: UITableViewCell!
    @IBOutlet weak var alertWarningPriorityCell: UITableViewCell!
    @IBOutlet weak var alertInformationPriorityCell: UITableViewCell!
    
    // TODO: Remove this, for debugging
    @IBOutlet weak var sendAlertNotificationCell: UITableViewCell!
    
    // This is the alert's type, which must be set
    // by the user to create a new alert. It is selected
    // from a seperate view controller (SelectAlertType),
    // and set here upon that view controller's dismissal.
    // var selectedAlertType: AlertType?
    var currentUser: User!
    var wellbore: Wellbore!
    
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
    var selectedCurve: Curve?
    
    func setSelectedCurve(curve: Curve) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.selectedCurve = curve
            if let curve = self.selectedCurve {
                self.curveIVTLabel.text = curve.IVT.toString()
                self.curveNameLabel.text = curve.name
                self.curveNameLabel.hidden = false
                self.curveIVTLabel.hidden = false
                self.noCurveSelectedLabel.hidden = true

            } else {
                self.curveIVTLabel.text = ""
                self.curveNameLabel.text = ""
                self.curveNameLabel.hidden = true
                self.curveIVTLabel.hidden = true
                self.noCurveSelectedLabel.hidden = false
            }
        })
    }
    
    override func viewDidLoad() {
        // We want to change the title 
        // of the page if the user is adding 
        // or editing an alert
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        if let placeholder = self.alertNameTextField.placeholder {
            self.alertNameTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
        }
        if let placeholder = self.alertValueTextField.placeholder {
            self.alertValueTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
        }
        if let alert = alertToEdit {
            // Set up the Edit view
            self.title = "Edit Alert"
            self.setupViewWithAlert(alert)
            self.curveNameLabel.hidden = false
            self.curveIVTLabel.hidden = false
            self.noCurveSelectedLabel.hidden = true
        } else {
            // Set up the Add view
            self.title = "Add Alert"
            self.curveNameLabel.hidden = true
            self.curveIVTLabel.hidden = true
            self.noCurveSelectedLabel.hidden = false
        }
        
        // Dismiss keyboard on anywhere tap
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapRecognizer)
        self.tableView.separatorColor = UIColor.blackColor()
        super.viewDidLoad()
    }
    
    func dismissKeyboard() {
        alertValueTextField.resignFirstResponder()
    }
    
    func setupViewWithAlert(alert: Alert) {
        self.alertNameTextField.text = alert.name
        self.alertValueTextField.text = "\(alert.threshold)"
        
        // Set the alert when cell
        if alert.rising {
            self.alertOnRiseCell.accessoryType = .Checkmark
            self.alertOnFallCell.accessoryType = .None
        } else {
            self.alertOnRiseCell.accessoryType = .None
            self.alertOnFallCell.accessoryType = .Checkmark
        }
        
        // Set the alert severity cell
        switch alert.priority {
            case .Critical: alertCriticalPriorityCell.accessoryType = .Checkmark
            case .Warning:  alertWarningPriorityCell.accessoryType = .Checkmark
            case .Information: alertInformationPriorityCell.accessoryType = .Checkmark
            default: break
        }
    
        
    }
    
    func getAlertRisingValue() -> Bool? {
        var result: Bool?
        
        // Only return a value if the user has selected one
        // of the alert when cells
        if alertOnRiseCell.accessoryType == .Checkmark || alertOnFallCell.accessoryType == .Checkmark {
            result = alertOnRiseCell.accessoryType == .Checkmark
        }
        
        return result
    }
    
    func getAlertPriorityValue() -> Priority? {
        var result: Priority?
        
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
            self.saveEditedAlert()
        } else {
            self.createNewAlert()
        }
        
    }
    
    func saveEditedAlert() {
        var alertMessage: String?
        self.view.endEditing(true)
    
        if let newName = alertNameTextField.text {
            if let newValueText = alertValueTextField.text {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                
                if let newValue = numberFormatter.numberFromString(newValueText) {
                    if let newRising = self.getAlertRisingValue() {
                        if let newPriority = self.getAlertPriorityValue() {
                            if let newAlert = alertToEdit {
                                
                                newAlert.name = newName
                                newAlert.rising = newRising
                                newAlert.priority = newPriority
                                newAlert.threshold = newValue.doubleValue
                                newAlert.save(self.currentUser, completion: { (error: NSError?) -> Void in
                                    if let error = error {
                                        let alertController = UIAlertController(title: "Error", message:
                                            "Unable to save Alert (\(error.code)).", preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
                                            
                                        }
                                        alertController.addAction(okayAction)
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                    } else {
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                })
                            } else {
                                alertMessage = "No alert to edit found."
                            }
                        } else {
                            alertMessage = "Please select the severity value."
                        }
                    } else {
                        alertMessage = "Please select the alert on rise value."
                    }
                } else {
                    alertMessage = "Please enter a valid value."
                }
            } else {
                alertMessage = "Please enter a value."
            }
        } else {
            alertMessage = "Please enter a name."
        }
        
    }
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let footer = view as? UITableViewHeaderFooterView {
            footer.textLabel.textColor = UIColor(red: 0.624, green: 0.627, blue: 0.643, alpha: 1.0)
            
        }
    }
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel.textColor = UIColor(red: 0.624, green: 0.627, blue: 0.643, alpha: 1.0)
        }
    }
    func createNewAlert() {
         var alertMessage: String?
        
        if let newName = alertNameTextField.text {
            if let newValueText = alertValueTextField.text {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .DecimalStyle
                
                if let newValue = numberFormatter.numberFromString(newValueText) {
                    if let newRising = self.getAlertRisingValue() {
                        if let newPriority = self.getAlertPriorityValue() {
                            if let curve = self.selectedCurve {
                                // TODO: Set Curve ID of New Alert
                                let newAlert = Alert(
                                    curveID: curve.id,
                                    userID: currentUser.id,
                                    name: newName,
                                    rising: newRising,
                                    priority: newPriority,
                                    threshold: newValue.doubleValue)
                                
                                newAlert.save(self.currentUser, completion: { (error) -> Void in
                                    if let error = error {
                                        let alertController = UIAlertController(
                                            title: "Error",
                                            message: "Unable to save Alert (\(error.code)).",
                                            preferredStyle: UIAlertControllerStyle.Alert)
                                        
                                        let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
                                            
                                        }
                                        
                                        alertController.addAction(okayAction)
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                    } else {
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                })
                            }
                        } else {
                            alertMessage = "Please choose an alert priority."
                        }
                    } else {
                        alertMessage = "Please select the alert on rise value."
                    }
                } else {
                    alertMessage = "Please enter a valid value."
                }
            } else {
                alertMessage = "Please enter a value."
            }
        } else {
            alertMessage = "Please enter a name."
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
    
    func sendTestNotification() {
        let URLString = "https://drillalert.azurewebsites.net/api/push/ios"
        
        if let URL = NSURL(string: URLString) {
            var newRequest = NSMutableURLRequest(URL: URL)
            newRequest.HTTPMethod = "GET"
            
            let userSession = currentUser.session
            if let session = userSession.session {
                let task = session.dataTaskWithRequest(newRequest, completionHandler: { (data, response, error) -> Void in
                    println("test Task: ")
                    if let content = NSString(data: data, encoding: NSASCIIStringEncoding) {
                        println("Data get: ")
                        println(content)
                        println("Response get:")
                        println(response)
                    }
                })
                
                task.resume()
            }
            
        }

    }
}

extension AddEditAlertTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let selectedCell = tableView.cellForRowAtIndexPath(indexPath) {
            switch indexPath.section {
            case self.alertNameSection:
                self.alertNameTextField.becomeFirstResponder()
            
            case self.alertValueSection:
                self.alertValueTextField.becomeFirstResponder()
            case alertWhenSection:
                alertOnFallCell.accessoryType = .None
                alertOnRiseCell.accessoryType = .None
                selectedCell.accessoryType = .Checkmark
            case alertPrioritySection:
                alertCriticalPriorityCell.accessoryType = .None
                alertWarningPriorityCell.accessoryType = .None
                alertInformationPriorityCell.accessoryType = .None
                selectedCell.accessoryType = .Checkmark
            case alertDebugSection:
                self.sendTestNotification()
            default: break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectAlertTypeTableViewController.getEntrySegueIdentifier() {
            let destinationViewController = segue.destinationViewController as! SelectAlertTypeTableViewController
            destinationViewController.delegate = self
        } else if segue.identifier == SelectCurveIVTTableViewController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! SelectCurveIVTTableViewController
            destination.delegate = self
        }
    }
}
