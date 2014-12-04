//
//  EditAlertTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 12/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddOrEditAlertTableViewController: UITableViewController {
    // Table View Sections & Rows
    let numberOfSections = 3
    let valueSection = 0
    let valueRow = 0
    
    let alertWhenSection = 1
    let parameterRisesToValueRow = 0
    let parameterFallsToValueRow = 1
    
    let prioritySection = 2
    let highPriorityRow = 0
    let lowPriorityRow = 1
    
    var alertToEdit: Alert?
    var delegate: AddParameterAlertTableViewController!
    
    @IBOutlet weak var alertValueTextfield: UITextField!
    @IBOutlet weak var alertWhenRisesCell: AlertWhenCell!
    @IBOutlet weak var alertWhenRisesLabel: UILabel!
    @IBOutlet weak var alertWhenFallsLabel: UILabel!
    @IBOutlet weak var alertWhenFallsCell: AlertWhenCell!
    @IBOutlet weak var highPriorityCell: UITableViewCell!
    @IBOutlet weak var lowPriorityCell: UITableViewCell!
   
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        if let alert = alertToEdit {
            // edit the alert
        } else {
            // add new alert
            if let value = alertValueTextfield.text.toInt() {
                var alertWhenRisesToValue: Bool
                var priority: Priority
                
                if alertWhenRisesCell.accessoryType == .Checkmark {
                    alertWhenRisesToValue = true
                } else {
                    alertWhenRisesToValue = false
                }
                
                if highPriorityCell.accessoryType == .Checkmark {
                    priority = Priority.High
                } else {
                    priority = Priority.Low
                }
                
                let newAlert = Alert(value: value, alertWhenRisesToValue: alertWhenRisesToValue, priority: priority)
                self.delegate.alerts.append(newAlert)
                self.delegate.reloadTableView()
            }
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        if let alert = alertToEdit {
            if let selectedParameter = delegate.selectedParameter {
                self.title = "Edit \(selectedParameter.name) Alert"
            } else {
                self.title = "Edit Alert"
            }
        } else {
            if let selectedParameter = delegate.selectedParameter {
                self.title = "Add \(selectedParameter.name) Alert"
            } else {
                self.title = "Add Alert"
            }
        }
        
        super.viewDidLoad()
    }
}

extension AddOrEditAlertTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case alertWhenSection:
            switch indexPath.row {
            case parameterRisesToValueRow:
                alertWhenRisesCell.accessoryType = .Checkmark
                alertWhenFallsCell.accessoryType = .None
            case parameterFallsToValueRow:
                alertWhenFallsCell.accessoryType = .Checkmark
                alertWhenRisesCell.accessoryType = .None
            default: break
            }
        case prioritySection:
            switch indexPath.row {
            case highPriorityRow:
                highPriorityCell.accessoryType = .Checkmark
                lowPriorityCell.accessoryType = .None
            case lowPriorityRow:
                lowPriorityCell.accessoryType = .Checkmark
                highPriorityCell.accessoryType = .None
            default: break
            }
        default: break
        }
    }
}