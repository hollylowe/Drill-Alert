//
//  AddEditTrackTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/12/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditTrackTableViewController: UITableViewController {
    //
    //  ---------------------------------
    // | Set by Previous View Controller |
    //  ---------------------------------
    //
    var trackToEdit: Track?
    var delegate: AddEditPlotTableViewController!
    var wellbore: Wellbore!
    var user: User!
    
    //
    //  --------------------------
    // | Current Track Properties |
    //  --------------------------
    //
    var selectedScaleType: PlotTrackScaleType?
    var curves = Array<Curve>()

    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    let numberOfSections = 4
    let trackNameSection = 0
    let trackPropertiesSection = 1
    let trackScaleTypeSection = 2
    let trackCurvesSection = 3
    
    //
    //  --------------------
    // | Table View Statics |
    //  --------------------
    //
    var trackNameTextField: UITextField?
    var trackDivisionSizeTextField: UITextField?
    
    
    override func viewDidLoad() {
        if let track = self.trackToEdit {
            self.title = "Edit Track"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelBarButtonTapped:")
            self.curves = track.curves
            self.selectedScaleType = track.scaleType
        } else {
            self.title = "Add Track"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelBarButtonTapped:")
        }
        super.viewDidLoad()
    }
    
    func addCurve(curve: Curve) {
        self.curves.append(curve)
        self.tableView.reloadData()
    }
    
    @IBAction func saveBarButtonTapped(sender: UIBarButtonItem) {
        if let trackNameTextField = self.trackNameTextField {
            if let trackDivisionSizeTextField = self.trackDivisionSizeTextField {
                if let name = trackNameTextField.text {
                    if let divisionSize = trackDivisionSizeTextField.text {
                        if let scaleType = self.selectedScaleType {
                            if let track = self.trackToEdit {
                                track.name = name
                                track.divisionSize = divisionSize
                                track.curves = self.curves
                                track.scaleType = scaleType
                                self.delegate.tableView.reloadData()
                            } else {
                                let newTrack = Track(
                                    xPosition: 0,
                                    yPosition: 0,
                                    name: name,
                                    divisionSize: divisionSize,
                                    curves: self.curves,
                                    scaleType: scaleType)
                                self.delegate.addTrack(newTrack)
                            }
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    func cancelBarButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetScaleTypeAccessoryTypes() {
        let rowCount = PlotTrackScaleType.allValues.count
        for row in 0...rowCount {
            let indexPath = NSIndexPath(forRow: row, inSection: self.trackScaleTypeSection)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectCurveNavigationController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! SelectCurveNavigationController
            let viewController = destination.viewControllers[0] as! SelectCurveTableViewController
            
            viewController.wellbore = self.wellbore
            viewController.user = self.user
            viewController.currentCurves = self.curves
            viewController.delegate = self
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
}

extension AddEditTrackTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case self.trackNameSection:
            if let textField = self.trackNameTextField {
                textField.becomeFirstResponder()
            }
        case self.trackPropertiesSection:
            if let textField = self.trackDivisionSizeTextField {
                textField.becomeFirstResponder()
            }
        case self.trackScaleTypeSection:
            self.resetScaleTypeAccessoryTypes()
            if indexPath.row < PlotTrackScaleType.allValues.count {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    cell.accessoryType = .Checkmark
                }
                self.selectedScaleType = PlotTrackScaleType.allValues[indexPath.row]
            }
        case self.trackCurvesSection:
            if indexPath.row < self.curves.count {
                let curve = self.curves[indexPath.row]
                // TODO:  pull up edit curve view
            } else if indexPath.row == self.curves.count {
                self.performSegueWithIdentifier(SelectCurveNavigationController.entrySegueIdentifier(), sender: nil)
            }
        default: break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension AddEditTrackTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result = ""
        
        switch section {
        case self.trackNameSection: result = ""
        case self.trackPropertiesSection: result = "Properties"
        case self.trackScaleTypeSection: result = "Scale Type"
        case self.trackCurvesSection: result = "Curves"
        default: result = ""
        }
        
        return result
    }
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.trackNameSection: numberOfRows = 1
        case self.trackPropertiesSection: numberOfRows = 1
        case self.trackScaleTypeSection: numberOfRows = PlotTrackScaleType.allValues.count
        case self.trackCurvesSection: numberOfRows = self.curves.count + 1
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.trackNameSection:
            let textFieldCell = tableView.dequeueReusableCellWithIdentifier(TextFieldCell.cellIdentifier()) as! TextFieldCell
            textFieldCell.textField.placeholder = "Track Name"
            if let track = self.trackToEdit {
                textFieldCell.textField.text = track.name
            }
            self.trackNameTextField = textFieldCell.textField
            cell = textFieldCell
        case self.trackPropertiesSection:
            let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
            textFieldDetailCell.textFieldLabel.text = "Division Size"
            textFieldDetailCell.textField.placeholder = "0.0"
            if let track = self.trackToEdit {
                textFieldDetailCell.textField.text = track.divisionSize
            }
            self.trackDivisionSizeTextField = textFieldDetailCell.textField
            cell = textFieldDetailCell
        case self.trackScaleTypeSection:
            let scaleType = PlotTrackScaleType.allValues[indexPath.row]
            cell = tableView.dequeueReusableCellWithIdentifier(LabelCell.cellIdentifier()) as! LabelCell
            if let label = cell.textLabel {
                label.text = scaleType.getTitle()
            }
            
            if let selectedScaleType = self.selectedScaleType {
                if scaleType == selectedScaleType {
                    cell.accessoryType = .Checkmark
                }
            }
        case self.trackCurvesSection:
            if indexPath.row == self.curves.count {
                // Add Track Cell
                cell = tableView.dequeueReusableCellWithIdentifier(LabelCell.cellIdentifier()) as! LabelCell
                if let label = cell.textLabel {
                    label.text = "Add Curve..."
                }
            } else if indexPath.row < self.curves.count {
                // Edit Curve Cell
                let curve = self.curves[indexPath.row]
                cell = tableView.dequeueReusableCellWithIdentifier(LabelDisclosureCell.cellIdentifier()) as! LabelDisclosureCell
                
                if let label = cell.textLabel {
                    label.text = curve.name
                }
            }
            
        default: break
        }
        return cell
    }
}