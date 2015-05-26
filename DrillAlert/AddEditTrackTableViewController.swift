//
//  AddEditTrackTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/12/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func integerValue() -> Int? {
        var result: Int?
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        
        if let newValue = numberFormatter.numberFromString(self.text) {
            result = newValue.integerValue
        }
        
        return result
    }
}

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
    // var selectedScaleType: PlotTrackScaleType?
    // var curves = Array<Curve>()

    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    let numberOfSections = 4
    let trackNameSection = 0
    
    let trackSizeSection = 1
    let xPositionRow = 0
    let yPositionRow = 1
    
    let trackPropertiesSection = 2
    let stepSizeRow = 0
    let startRangeRow = 1
    let endRangeRow = 2
    let divisionSizeRow = 3
    let scaleTypeRow = 4
    
    // let trackCurvesSection = 3
    
    //
    //  --------------------
    // | Table View Statics |
    //  --------------------
    //
    var trackNameTextField: UITextField?
    
    // Track Size Section
    var xPositionTextField: UITextField?
    var yPositionTextField: UITextField?

    // Track Properties Section
    var stepSizeTextField: UITextField?
    var startRangeTextField: UITextField?
    var endRangeTextField: UITextField?
    var divisionSizeTextField: UITextField?
    var scaleTypeTextField: UITextField?

    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorColor = UIColor.blackColor()
        if let track = self.trackToEdit {
            self.title = "Edit Track"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonTapped:")
            // self.curves = track.curves
            // self.selectedScaleType = track.scaleType
        } else {
            self.title = "Add Track"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonTapped:")
        }
        
        if let saveButton = self.navigationItem.rightBarButtonItem {
            saveButton.tintColor = UIColor(red: 0.490, green: 0.733, blue: 0.910, alpha: 1.0)
            
        }
        
        super.viewDidLoad()
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
    /*
    func addCurve(curve: Curve) {
        self.curves.append(curve)
        self.tableView.reloadData()
    }
    */
    
    
    
    @IBAction func saveBarButtonTapped(sender: UIBarButtonItem) {
        var error: String?
        var opName: String?
        var opXPosition: Int?
        var opYPosition: Int?
        
        var opStepSize: Int?
        var opStartRange: Int?
        var opEndRange: Int?
        var opDivisionSize: Int?
        var opScaleType: Int?
        
        if let trackNameTextField = self.trackNameTextField {
            if !trackNameTextField.text.isEmpty {
                opName = trackNameTextField.text
            }
        }
        
        opXPosition = self.xPositionTextField?.integerValue()
        opYPosition = self.yPositionTextField?.integerValue()
        opStepSize = self.stepSizeTextField?.integerValue()
        opStartRange = self.startRangeTextField?.integerValue()
        opEndRange = self.endRangeTextField?.integerValue()
        opDivisionSize = self.divisionSizeTextField?.integerValue()
        opScaleType = self.scaleTypeTextField?.integerValue()

        if let name = opName {
            if let xPosition = opXPosition {
                if let yPosition = opYPosition {
                    if let stepSize = opStepSize {
                        if let startRange = opStartRange {
                            if let endRange = opEndRange {
                                if let divisionSize = opDivisionSize {
                                    if let scaleType = opScaleType {
                                        var newTrackSettings = ItemSettings(
                                            stepSize: stepSize,
                                            startRange: startRange,
                                            endRange: endRange,
                                            divisionSize: divisionSize,
                                            scaleType: scaleType)
                                        
                                        if let oldTrack = self.trackToEdit {
                                            oldTrack.name = name
                                            newTrackSettings.id = oldTrack.trackSettings?.id
                                            newTrackSettings.itemID = oldTrack.trackSettings?.itemID
                                            
                                            oldTrack.trackSettings = newTrackSettings
                                            oldTrack.itemSettingsCollection = ItemSettingsCollection(array: [newTrackSettings])
                                            oldTrack.xPosition = xPosition
                                            oldTrack.yPosition = yPosition
                                            
                                            self.delegate.tableView.reloadData()
                                        } else {
                                            let newTrack = Track(
                                                xPosition: xPosition,
                                                yPosition: yPosition,
                                                name: name,
                                                trackSettings: newTrackSettings)
                                            self.delegate.addTrack(newTrack)
                                        }
                                        
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    } else {
                                        error = "Please enter a valid Scale Type."
                                    }
                                } else {
                                    error = "Please enter a valid Division Size."
                                }
                            } else {
                                error = "Please enter a valid End Range."
                            }
                        } else {
                            error = "Please enter a valid Start Range."
                        }
                    } else {
                        error = "Please enter a valid Step Size."
                    }
                } else {
                    error = "Please enter a valid Y Position."
                }
            } else {
                error = "Please enter a valid X Position."
            }
        } else {
            error = "Please enter a name."
        }
        
        if (error != nil) {
            let alertController = UIAlertController(
                title: "Error",
                message: error!,
                preferredStyle: .Alert)
            
            let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
                
            }
            
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func cancelBarButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    func resetScaleTypeAccessoryTypes() {
        let rowCount = PlotTrackScaleType.allValues.count
        for row in 0...rowCount {
            let indexPath = NSIndexPath(forRow: row, inSection: self.trackScaleTypeSection)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectCurveNavigationController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! SelectCurveNavigationController
            let viewController = destination.viewControllers[0] as! SelectCurveTableViewController
            
            viewController.wellbore = self.wellbore
            viewController.user = self.user
            // viewController.currentCurves = self.curves
            viewController.delegate = self
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
}

extension AddEditTrackTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case self.trackNameSection: self.trackNameTextField?.becomeFirstResponder()
        case self.trackSizeSection:
            switch indexPath.row {
                case self.xPositionRow: self.xPositionTextField?.becomeFirstResponder()
                case self.yPositionRow: self.yPositionTextField?.becomeFirstResponder()
                default: break
            }
        case self.trackPropertiesSection:
            switch indexPath.row {
            case self.stepSizeRow: self.stepSizeTextField?.becomeFirstResponder()
            case self.startRangeRow: self.startRangeTextField?.becomeFirstResponder()
            case self.endRangeRow: self.endRangeTextField?.becomeFirstResponder()
            case self.divisionSizeRow: self.divisionSizeTextField?.becomeFirstResponder()
            case self.scaleTypeRow: self.scaleTypeTextField?.becomeFirstResponder()
            default: break
            }
            /*
        case self.trackCurvesSection:
            if indexPath.row < self.curves.count {
                let curve = self.curves[indexPath.row]
                // TODO:  pull up edit curve view
            } else if indexPath.row == self.curves.count {
                self.performSegueWithIdentifier(SelectCurveNavigationController.entrySegueIdentifier(), sender: nil)
            }
            */
        default: break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension AddEditTrackTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result = ""
        
        switch section {
        case self.trackNameSection: result = "Name"
        case self.trackSizeSection: result = "Size"
        case self.trackPropertiesSection: result = "Properties"
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
        case self.trackSizeSection: numberOfRows = 2
        case self.trackPropertiesSection: numberOfRows = 5
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.trackNameSection:
            let textFieldCell = tableView.dequeueReusableCellWithIdentifier(TextFieldCell.cellIdentifier()) as! TextFieldCell
            textFieldCell.textField.placeholder = "Enter a name"
            if let track = self.trackToEdit {
                textFieldCell.textField.text = track.name
            }
            if let placeholder = textFieldCell.textField.placeholder {
                textFieldCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
            }
            
            
            self.trackNameTextField = textFieldCell.textField
            cell = textFieldCell
        case self.trackSizeSection:
            switch indexPath.row {
            case self.xPositionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "X Position"
                textFieldDetailCell.textField.placeholder = "0"
                
                if let track = self.trackToEdit {
                    textFieldDetailCell.textField.text = "\(track.xPosition)"
                }
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                
                self.xPositionTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.yPositionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "Y Position"
                textFieldDetailCell.textField.placeholder = "0"
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                if let track = self.trackToEdit {
                    textFieldDetailCell.textField.text = "\(track.yPosition)"
                }
                self.yPositionTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            default: break
            }
        case self.trackPropertiesSection:
            switch indexPath.row {
            case self.stepSizeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "Step Size"
                textFieldDetailCell.textField.placeholder = "0"
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldDetailCell.textField.text = "\(trackSettings.stepSize)"
                    }
                }
                self.stepSizeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.startRangeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "Start Range"
                textFieldDetailCell.textField.placeholder = "0"
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldDetailCell.textField.text = "\(trackSettings.startRange)"
                    }
                }
                self.startRangeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.endRangeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "End Range"
                textFieldDetailCell.textField.placeholder = "0"
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldDetailCell.textField.text = "\(trackSettings.endRange)"
                    }
                }
                self.endRangeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.divisionSizeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "Division Size"
                textFieldDetailCell.textField.placeholder = "0"
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldDetailCell.textField.text = "\(trackSettings.divisionSize)"
                    }
                }
                self.divisionSizeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.scaleTypeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "Scale Type"
                textFieldDetailCell.textField.placeholder = "0"
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldDetailCell.textField.text = "\(trackSettings.scaleType)"
                    }
                }
                self.scaleTypeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            default: break
            }
            
          /*
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
            */
        default: break
        }
        return cell
    }
}