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
    var shouldShowConfirmationDialog = false
    //
    //  ---------------------------------
    // | Set by Previous View Controller |
    //  ---------------------------------
    //
    var trackToSave: Track?
    var trackToEdit: Track?
    var trackToEditIndex: Int?
    var dashboardPriorToEdit: Dashboard?
    var addEditPlotDelegate: AddEditPlotTableViewController!
    var wellbore: Wellbore!
    var user: User!

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
    
    var isDisabled = false
    var activityBarButtonItem: UIBarButtonItem!
    var saveBarButtonItem: UIBarButtonItem!

    private func disableView() {
        self.isDisabled = true
        self.xPositionTextField?.enabled = false
        self.yPositionTextField?.enabled = false
        
        self.stepSizeTextField?.enabled = false
        self.startRangeTextField?.enabled = false
        self.endRangeTextField?.enabled = false
        self.divisionSizeTextField?.enabled = false
        self.scaleTypeTextField?.enabled = false
        
    }
    
    private func enableView() {
        self.isDisabled = false
        self.xPositionTextField?.enabled = true
        self.yPositionTextField?.enabled = true
        
        self.stepSizeTextField?.enabled = true
        self.startRangeTextField?.enabled = true
        self.endRangeTextField?.enabled = true
        self.divisionSizeTextField?.enabled = true
        self.scaleTypeTextField?.enabled = true
        
    }
    
    private func showActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.activityBarButtonItem, animated: true)
        self.disableView()
    }
    
    private func hideActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
        self.enableView()
    }
    
    func loadItemCurvesForTrack(track: Track) {
        
        if let id = track.id {
            self.showActivityBarButton()

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                var itemCurves = ItemCurve.getItemCurvesForUser(self.user, andItemID: id)
                let (opCurves, opError) = Curve.addCurvesToItemCurves(itemCurves, user: self.user, andWellbore: self.wellbore)
                
                if let error = opError {
                    println("Error loading curves for item curves: \(error)")
                } else {
                    if let newItemCurves = opCurves {
                        println("Recieved new item curves successfully.")
                        self.trackToSave!.itemCurves = newItemCurves
                    } else {
                        self.trackToSave!.itemCurves = Array<ItemCurve>()
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.hideActivityBarButton()
                })
            })
        } else {
            println("Error: Attempted to get curves for a track that is being edited, however there was no ID.")
        }
        
    }
    
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorColor = UIColor.blackColor()
        
        let activityView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 25, 25))
        activityView.startAnimating()
        activityView.hidden = false
        activityView.color = UIColor.grayColor()
        activityView.sizeToFit()
        activityView.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
        
        self.activityBarButtonItem = UIBarButtonItem(customView: activityView)
        self.saveBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .Done,
            target: self,
            action: "saveButtonTapped:")
        if let saveButton = self.saveBarButtonItem {
            saveButton.tintColor = UIColor.SDIBlue()
        }
        
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
        
        if let track = self.trackToEdit {
            self.title = "Edit Track"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonTapped:")
            if let id = track.id {
                self.trackToSave = Track(
                    id: id,
                    xPosition: track.xPosition,
                    yPosition: track.yPosition,
                    itemSettingsCollection: track.itemSettingsCollection)
            } else {
                self.trackToSave = Track(
                    xPosition: track.xPosition,
                    yPosition: track.yPosition,
                    itemSettingsCollection: track.itemSettingsCollection)
                println("Warning: Track to edit had no ID.")
            }
            
            self.loadItemCurvesForTrack(track)
        } else {
            self.title = "Add Track"
            self.trackToSave = Track()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonTapped:")
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
    
    func addItemCurve(itemCurve: ItemCurve) {
        if let track = self.trackToSave {
            track.itemCurves.append(itemCurve) 
        } else {
            println("Error: No track to save when adding item curve.")
        }
        self.tableView.reloadData()
    }
    
    /*
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
    */
    func syncTrackWithPlotAndDashboardWithCallback(callback: ((error: String?, newestID: Int?) -> Void)) {
        self.shouldShowConfirmationDialog = true
        
        if let newTrack = self.trackToSave {
            if let oldTrack = self.trackToEdit {
                if let index = self.trackToEditIndex {
                    self.addEditPlotDelegate.swapTrackAtIndex(index, withTrack: newTrack)
                }
            } else {
                self.addEditPlotDelegate.addTrack(newTrack)
            }
            
            self.addEditPlotDelegate.syncPlotWithDashboardWithCallback({ (error, newestID) -> Void in
                if error == nil {
                    if newTrack.id == nil {
                        self.trackToSave?.id = newestID
                        callback(error: nil, newestID: nil)
                    } else {
                        callback(error: nil, newestID: newestID)
                    }
                    
                } else {
                    callback(error: "Error syncing dashboard: \(error!).", newestID: nil)
                }
            })
            
            
        } else {
            callback(error: "Error: No track to save.", newestID: nil)
        }
        
    }
    
    func saveButtonTapped(sender: UIBarButtonItem) {
        self.showActivityBarButton()
        self.saveTrackWithCallback { (error, newestID) -> Void in
            self.hideActivityBarButton()
            if (error != nil) {
                let alertController = UIAlertController(
                    title: "Error",
                    message: error!,
                    preferredStyle: .Alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
                    
                }
                
                alertController.addAction(okayAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        
    }
    
    func cancelBarButtonTapped(sender: UIBarButtonItem) {
        if !self.isDisabled {
            // If a user is editing a track, but they
            // then hit cancel, we need to discard any
            // changes they may have made.
            if let oldTrack = self.trackToEdit {
                if self.shouldShowConfirmationDialog {
                    let alert = UIAlertController(
                        title: "Are you sure?",
                        message: "Your changes to this track will be lost.",
                        preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (alertAction) -> Void in
                        // If we are canceling our changes to the plot,
                        // We need to update what is on the backend to what
                        // was there prior to the edit.
                        println("Reverting edited track...")
                        self.showActivityBarButton()
                        if let track = self.trackToSave {
                            track.itemCurves = oldTrack.itemCurves
                            track.itemSettingsCollection = oldTrack.itemSettingsCollection
                            track.xPosition = oldTrack.xPosition
                            track.yPosition = oldTrack.yPosition
                            
                            self.saveTrackWithCallback({ (error, newestID) -> Void in
                                self.hideActivityBarButton()
                                if error == nil {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                } else {
                                    println("Error reverting track: \(error!)")
                                }
                            })
                            
                        }
                    }))
                    
                    alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                // Otherwise, the user is canceling a Add Track operation.
                // The track may have been saved to the backend already,
                // however. This means we need to revert the entire dashboard.
                
                /*
                if let dashboard = self.dashboardToSave {
                self.showActivity()
                println("Removing added dashboard...")
                Dashboard.deleteDashboard(dashboard, forUser: self.user, withCallback: { (error) -> Void in
                self.hideActivity()
                if error == nil {
                println("Dashboard \(dashboard.id) successfully deleted.")
                self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                println("Dashboard not deleted. Error: \(error!)")
                self.dismissViewControllerAnimated(true, completion: nil)
                }
                })
                }
                */
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectCurveIVTTableViewController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! SelectCurveIVTTableViewController
            
            if let curveIndex = sender as? Int {
                if let track = self.trackToSave {
                    let itemCurve = track.itemCurves[curveIndex]
                    destination.curveToEdit = itemCurve.curve
                }
            }
            
            destination.addEditTrackDelegate = self
            destination.user = self.user
            destination.wellbore = self.wellbore
            if let track = self.trackToSave {
                destination.itemID = track.id
            }
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    
}

extension AddEditTrackTableViewController: UITableViewDelegate {
    func saveTrackWithCallback(callback: ((error: String?, newestID: Int?) -> Void)) {
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
                                        
                                        // If the user was editing a track,
                                        // we should set the new track settings
                                        // id and item id to those values.
                                        
                                        if let oldTrack = self.trackToEdit {
                                            if oldTrack.itemSettingsCollection.array.count > 0 {
                                                let oldItemSettings = oldTrack.itemSettingsCollection.array[0]
                                                newTrackSettings.id = oldItemSettings.id
                                                newTrackSettings.itemID = oldItemSettings.itemID
                                            }
                                            if let track = self.trackToSave {
                                                // Set the track to the new values
                                                track.xPosition = xPosition
                                                track.yPosition = yPosition
                                                track.itemSettingsCollection = ItemSettingsCollection(array: [newTrackSettings])
                                                
                                                
                                            } else {
                                                println("Error: No track To Save.")
                                            }
                                        } else {
                                            // Set the track to the new values

                                            if let track = self.trackToSave {
                                                track.xPosition = xPosition
                                                track.yPosition = yPosition
                                                track.itemSettingsCollection = ItemSettingsCollection(array: [newTrackSettings])
                                            } else {
                                                println("Error: No track To Save.")
                                            }
                                        }
                                        
                                        self.syncTrackWithPlotAndDashboardWithCallback({ (error, newestID) -> Void in
                                            if error == nil {
                                                callback(error: nil, newestID: nil)
                                                
                                            } else {
                                                callback(error: "Error syncing track: \(error!).", newestID: nil)
                                            }
                                        })
                                        
                                    } else {
                                        callback(error: "Please enter a valid Scale Type.", newestID: nil)
                                    }
                                } else {
                                    callback(error: "Please enter a valid Division Size.", newestID: nil)
                                }
                            } else {
                                callback(error: "Please enter a valid End Range.", newestID: nil)
                            }
                        } else {
                            callback(error: "Please enter a valid Start Range.", newestID: nil)
                        }
                    } else {
                        callback(error: "Please enter a valid Step Size.", newestID: nil)
                    }
                } else {
                    callback(error: "Please enter a valid Y Position.", newestID: nil)
                }
            } else {
                callback(error: "Please enter a valid X Position.", newestID: nil)
            }
        } else {
            callback(error: "Please enter a name.", newestID: nil)
        }
        

        
    }
    
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
            if let track = self.trackToSave {
                if indexPath.row < track.itemCurves.count {
                    
                    self.performSegueWithIdentifier(SelectCurveIVTTableViewController.entrySegueIdentifier(), sender: indexPath.row)
                    
                } else if indexPath.row == track.itemCurves.count {
                    // Save the track first 
                    self.showActivityBarButton()
                
                    self.saveTrackWithCallback({ (error, newestID) -> Void in
                        self.hideActivityBarButton()
                        if error == nil {
                            self.performSegueWithIdentifier(SelectCurveIVTTableViewController.entrySegueIdentifier(), sender: nil)
                        } else {
                            println("Error syncing track: \(error!)")
                        }
                        
                    })
                    
                }
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
        case self.trackCurvesSection:
            if let track = self.trackToSave {
                numberOfRows = track.itemCurves.count + 1
            }
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    private func createTrackNameCell() -> TextFieldCell {
        let textFieldCell = tableView.dequeueReusableCellWithIdentifier(TextFieldCell.cellIdentifier()) as! TextFieldCell
        textFieldCell.textField.placeholder = "Enter a name"
        if let track = self.trackToEdit {
            if let id = track.id {
                textFieldCell.textField.text = "Track \(id)"
            }
        }
        if let placeholder = textFieldCell.textField.placeholder {
            textFieldCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
        }
        
        self.trackNameTextField = textFieldCell.textField
        textFieldCell.textField.enabled = false
        return textFieldCell
    }
    
    private func createTrackCurvesCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if let track = self.trackToSave {
            if indexPath.row == track.itemCurves.count {
                cell = tableView.dequeueReusableCellWithIdentifier(AddCurveCell.cellIdentifier()) as! AddCurveCell
            } else if indexPath.row < track.itemCurves.count {
                // Edit Curve Cell
                let itemCurve = track.itemCurves[indexPath.row]
                if let curve = itemCurve.curve {
                    let curveCell = tableView.dequeueReusableCellWithIdentifier(CurveCell.cellIdentifier()) as! CurveCell
                    curveCell.setupWithCurve(curve)
                    cell = curveCell
                }
            }
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
                textFieldDetailCell.textField.enabled = true

                self.xPositionTextField = textFieldDetailCell.textField

                cell = textFieldDetailCell
            case self.yPositionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?

                if let track = self.trackToEdit {
                    textFieldText = String(track.yPosition)
                }
                
                textFieldDetailCell.setupWithLabelText("Y Position", placeholder: "0", andTextFieldText: textFieldText)
                textFieldDetailCell.textField.enabled = true

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
                    if track.itemSettingsCollection.array.count > 0  {
                        textFieldText = String(track.itemSettingsCollection.array[0].stepSize)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Step Size", placeholder: "0", andTextFieldText: textFieldText)
                textFieldDetailCell.textField.enabled = true

                self.stepSizeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.startRangeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if track.itemSettingsCollection.array.count > 0  {
                        textFieldText = String(track.itemSettingsCollection.array[0].startRange)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Start Range", placeholder: "0", andTextFieldText: textFieldText)
                textFieldDetailCell.textField.enabled = true

                self.startRangeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.endRangeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if track.itemSettingsCollection.array.count > 0  {
                        textFieldText = String(track.itemSettingsCollection.array[0].endRange)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("End Range", placeholder: "0", andTextFieldText: textFieldText)
                textFieldDetailCell.textField.enabled = true

                self.endRangeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.divisionSizeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if track.itemSettingsCollection.array.count > 0  {
                        textFieldText = String(track.itemSettingsCollection.array[0].divisionSize)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Division Size", placeholder: "0", andTextFieldText: textFieldText)
                textFieldDetailCell.textField.enabled = true

                self.divisionSizeTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            case self.scaleTypeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                var textFieldText: String?
                
                if let track = self.trackToEdit {
                    if track.itemSettingsCollection.array.count > 0  {
                        textFieldText = String(track.itemSettingsCollection.array[0].scaleType)
                    }
                }
                
                textFieldDetailCell.setupWithLabelText("Scale Type", placeholder: "0", andTextFieldText: textFieldText)
                textFieldDetailCell.textField.enabled = true

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