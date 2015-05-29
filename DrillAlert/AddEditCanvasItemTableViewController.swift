//
//  AddEditCanvasItemTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditCanvasItemTableViewController: UITableViewController {
    //
    //  ----------------
    // | Previously Set |
    //  ----------------
    //
    var delegate: AddEditCanvasTableViewController!
    var canvasItemToEdit: CanvasItem?

    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    var canvasItemNameTextField: UITextField?
    var xPositionTextField: UITextField?
    var yPositionTextField: UITextField?
    
    let numberOfSections            = 3
    let canvasItemNameSection       = 0
    let canvasItemPositionSection   = 1
    let canvasItemTypeSection       = 2
    let canvasItemCurvesSection     = 3
    
    let xPositionRow                = 0
    let yPositionRow                = 1
    var selectedTypeIndex           = -1
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        var error: String?
        var opName: String?
        var opXPosition: Int?
        var opYPosition: Int?
        var opType: CanvasItemType?
        
        if self.selectedTypeIndex >= 0 && self.selectedTypeIndex < CanvasItemType.allValues.count {
            opType = CanvasItemType.allValues[self.selectedTypeIndex]
        }
        
        opName = self.canvasItemNameTextField?.text
        opXPosition = self.xPositionTextField?.integerValue()
        opYPosition = self.yPositionTextField?.integerValue()
        
        if let name = opName {
            if let xPosition = opXPosition {
                if let yPosition = opYPosition {
                    if let type = opType {
                        if let canvasItem = self.canvasItemToEdit {
                            canvasItem.xPosition = xPosition
                            canvasItem.yPosition = yPosition
                            canvasItem.type = type
                            canvasItem.name = name
                            
                            self.delegate.refreshCanvasItems()
                        } else {
                            let newCanvasItem = CanvasItem(
                                xPosition: xPosition,
                                yPosition: yPosition,
                                type: type,
                                name: name)
                            
                            self.delegate.addCanvasItem(newCanvasItem)
                        }
                        self.dismissViewControllerAnimated(true, completion: nil)

                    } else {
                        error = "Please choose a Type."
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
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.tableView.separatorColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        if let canvasItem = self.canvasItemToEdit {
            self.title = "Edit Canvas Item"
        } else {
            self.title = "Add Canvas Item"
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
    class func storyboardIdentifier() -> String {
        return "AddEditCanvasItemTableViewController"
    }
    
    class func entrySegueIdentifier() -> String {
        return "AddEditCanvasItemTableViewControllerSegue"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.canvasItemNameSection: numberOfRows = 1
        case self.canvasItemPositionSection: numberOfRows = 2
        case self.canvasItemTypeSection: numberOfRows = CanvasItemType.allValues.count
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section {
        case self.canvasItemNameSection: title = "Name"
        case self.canvasItemPositionSection: title = "Position"
        case self.canvasItemTypeSection: title = "Type"
        default: title = ""
        }
        
        return title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.canvasItemNameSection:
            let textFieldCell = tableView.dequeueReusableCellWithIdentifier(TextFieldCell.cellIdentifier()) as! TextFieldCell
            self.canvasItemNameTextField = textFieldCell.textField
            textFieldCell.textField.placeholder = "Enter a name"
            if let placeholder = textFieldCell.textField.placeholder {
                textFieldCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
            }
            if let canvasItem = self.canvasItemToEdit {
                textFieldCell.textField.text = canvasItem.name
            }
            
            cell = textFieldCell
        case self.canvasItemPositionSection:
            switch indexPath.row {
            case self.xPositionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell
                textFieldDetailCell.textFieldLabel.text = "X Position"
                textFieldDetailCell.textField.placeholder = "0"
                if let placeholder = textFieldDetailCell.textField.placeholder {
                    textFieldDetailCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                if let canvasItem = self.canvasItemToEdit {
                    textFieldDetailCell.textField.text = "\(canvasItem.xPosition)"
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
                if let canvasItem = self.canvasItemToEdit {
                    textFieldDetailCell.textField.text = "\(canvasItem.yPosition)"
                }
                self.yPositionTextField = textFieldDetailCell.textField
                cell = textFieldDetailCell
            default: break
            }
        case self.canvasItemTypeSection:
            let canvasItemType = CanvasItemType.allValues[indexPath.row]
            let canvasItemTypeCell = tableView.dequeueReusableCellWithIdentifier(CanvasItemTypeTableViewCell.cellIdentifier()) as! CanvasItemTypeTableViewCell
            
            if let canvasItem = self.canvasItemToEdit {
                if canvasItemType == canvasItem.type {
                    self.selectedTypeIndex = indexPath.row
                    canvasItemTypeCell.accessoryType = .Checkmark
                }
            }
            
            canvasItemTypeCell.setupWithCanvasItemType(canvasItemType)
            cell = canvasItemTypeCell
        
        default: break
        }
        
        return cell
    }
    
    func resetAccessoryTypesForSection(section: Int) {
        let rows = self.tableView.numberOfRowsInSection(section)
        for row in 0...rows {
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                cell.accessoryType = .None
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case self.canvasItemNameSection: self.canvasItemNameTextField?.becomeFirstResponder()
        case self.canvasItemPositionSection:
            switch indexPath.row {
            case self.xPositionRow: self.xPositionTextField?.becomeFirstResponder()
            case self.yPositionRow: self.yPositionTextField?.becomeFirstResponder()
            default: break
            }
        case self.canvasItemTypeSection:
            // Add a check mark to the row
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                self.resetAccessoryTypesForSection(indexPath.section)
                cell.accessoryType = .Checkmark
                if indexPath.row < CanvasItemType.allValues.count {
                    self.selectedTypeIndex = indexPath.row
                }
            }
        default: break
        }
    }
}