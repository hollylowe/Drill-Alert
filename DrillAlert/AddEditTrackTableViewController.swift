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
    var curves = Array<Curve>()

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
    
    let trackCurvesSection = 3
    
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

    var loadingData = true
    var loadError = false
    
    func loadCurvesForTrack(track: Track) {
        if let id = track.id {
            loadError = false
            loadingData = true
            
            // TODO: This will need to change if we add a way to refresh this page, which we probably will.
            // Instead, we could use the NSURLConnection asynchrounous call. This is because users could
            // refresh the page faster than this call could load it, resulting in multiple threads doing
            // the same operation and messing up the table view.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                var itemCurves = ItemCurve.getItemCurvesForUser(self.user, andItemID: id)
                let (opCurves, opError) = Curve.getCurvesForUser(self.user, wellbore: self.wellbore, fromItemCurves: itemCurves)
                if let error = opError {
                    println("Error loading curves: \(error)")
                } else {
                    if let curves = opCurves {
                        self.curves = curves
                    } else {
                        self.curves = Array<Curve>()
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.loadingData = false
                    self.tableView.reloadData()
                })
            })
        }
        
    }
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorColor = UIColor.blackColor()
        if let track = self.trackToEdit {
            self.title = "Edit Track"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonTapped:")
            self.loadCurvesForTrack(track)
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
    
    func addCurve(curve: Curve) {
        self.curves.append(curve)
        self.tableView.reloadData()
    }
    
    func swapOldCurve(oldCurve: Curve, withNewCurve newCurve: Curve) {
        var curveIndex = 0
        var toRemoveIndex: Int?
        for curve in self.curves {
            if curve.id == oldCurve.id {
                toRemoveIndex = curveIndex
                break
            }
            
            curveIndex++
        }
        
        if let index = toRemoveIndex {
            self.curves.removeAtIndex(index)
            self.curves.insert(newCurve, atIndex: index)
        }
        
        self.tableView.reloadData()
        
    }
    
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
                                            
                                            var newItemCurves = [ItemCurve]()
                                            for curve in self.curves {
                                                newItemCurves.append(ItemCurve(curveID: curve.id))
                                            }
                                            oldTrack.curves = self.curves
                                            oldTrack.itemCurves = newItemCurves
                                            self.delegate.tableView.reloadData()
                                        } else {
                                            let newTrack = Track(
                                                xPosition: xPosition,
                                                yPosition: yPosition,
                                                name: name,
                                                trackSettings: newTrackSettings,
                                                curves: self.curves)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectCurveIVTTableViewController.entrySegueIdentifier() {
            if let curve = sender as? Curve {
                let destination = segue.destinationViewController as! SelectCurveIVTTableViewController
                destination.addEditTrackDelegate = self
                destination.user = self.user
                destination.wellbore = self.wellbore
                destination.curveToEdit = curve
            } else {
                let destination = segue.destinationViewController as! SelectCurveIVTTableViewController
                destination.addEditTrackDelegate = self
                destination.user = self.user
                destination.wellbore = self.wellbore
            }
            
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
        case self.trackCurvesSection:
            if indexPath.row < self.curves.count {
                let curve = self.curves[indexPath.row]
                // TODO:  pull up edit curve view
                self.performSegueWithIdentifier(SelectCurveIVTTableViewController.entrySegueIdentifier(), sender: curve)
                
            } else if indexPath.row == self.curves.count {
                self.performSegueWithIdentifier(SelectCurveIVTTableViewController.entrySegueIdentifier(), sender: nil)
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
        case self.trackCurvesSection: numberOfRows = self.curves.count + 1
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    private func createTrackNameCell() -> TextFieldCell {
        let textFieldCell = tableView.dequeueReusableCellWithIdentifier(TextFieldCell.cellIdentifier()) as! TextFieldCell
        textFieldCell.textField.placeholder = "Enter a name"
        if let track = self.trackToEdit {
            textFieldCell.textField.text = track.name
        }
        if let placeholder = textFieldCell.textField.placeholder {
            textFieldCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
        }
        
        self.trackNameTextField = textFieldCell.textField
        return textFieldCell
    }
    
    private func createTrackCurvesCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        
        if indexPath.row == self.curves.count {
            cell = tableView.dequeueReusableCellWithIdentifier(AddCurveCell.cellIdentifier()) as! AddCurveCell
        } else if indexPath.row < self.curves.count {
            // Edit Curve Cell
            let curve = self.curves[indexPath.row]
            let curveCell = tableView.dequeueReusableCellWithIdentifier(CurveCell.cellIdentifier()) as! CurveCell
            curveCell.setupWithCurve(curve)
            cell = curveCell
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat = 44.0
        if indexPath.section == self.trackCurvesSection {
            rowHeight = 63.0
        }
        
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.trackNameSection: cell = self.createTrackNameCell()
        case self.trackSizeSection:
            switch indexPath.row {
            case self.xPositionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                if let track = self.trackToEdit {
                    textFieldText = String(track.xPosition)
                }
                
                textFieldDetailCell.setupWithLabelText("X Position", placeholder: "0", andTextFieldText: textFieldText)
                self.xPositionTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.yPositionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?

                if let track = self.trackToEdit {
                    textFieldText = String(track.yPosition)
                }
                
                textFieldDetailCell.setupWithLabelText("Y Position", placeholder: "0", andTextFieldText: textFieldText)
                self.yPositionTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            default: break
            }
        case self.trackPropertiesSection:
            switch indexPath.row {
            case self.stepSizeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldText = String(trackSettings.stepSize)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Step Size", placeholder: "0", andTextFieldText: textFieldText)
                
                self.stepSizeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.startRangeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldText = String(trackSettings.startRange)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Start Range", placeholder: "0", andTextFieldText: textFieldText)
                
                self.startRangeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.endRangeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldText = String(trackSettings.endRange)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("End Range", placeholder: "0", andTextFieldText: textFieldText)
                
                self.endRangeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.divisionSizeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldText = String(trackSettings.divisionSize)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Division Size", placeholder: "0", andTextFieldText: textFieldText)
                
                self.divisionSizeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.scaleTypeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if let trackSettings = track.trackSettings {
                        textFieldText = String(trackSettings.scaleType)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Scale Type", placeholder: "0", andTextFieldText: textFieldText)
                
                self.scaleTypeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            default: break
            }
        case self.trackCurvesSection: cell = createTrackCurvesCellForIndexPath(indexPath)

        default: break
        }
        return cell
    }
}