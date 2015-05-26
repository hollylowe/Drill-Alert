//
//  AddEditCanvasTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit


class AddEditCanvasTableViewController: UITableViewController {
    //
    //  ----------------
    // | Previously Set |
    //  ----------------
    //
    var delegate:       AddEditDashboardTableViewController!
    var canvasToEdit:   Page?
    var existingCanvas: Page?
    
    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    // Sections
    let numberOfSections   = 3
    let canvasNameSection  = 0
    let canvasSizeSection  = 1
    let canvasItemsSection = 2
    
    // Rows
    let canvasNameRow = 0
    let xDimensionRow = 0
    let yDimensionRow = 1
    
    // Data for Canvas Items Section
    var canvasItems = Array<CanvasItem>()
    var canvasNameTextField: UITextField?
    var xDimensionTextField: UITextField?
    var yDimensionTextField: UITextField?
    
    //
    //  -----------------
    // | Class Functions |
    //  -----------------
    //
    class func addCanvasFromExistingSegue() -> String {
        return "AddCanvasFromExistingSegue"
    }
    
    class func storyboardIdentifier() -> String {
        return "AddEditCanvasTableViewController"
    }
    
    class func addCanvasEntrySegueIdentifier() -> String {
        return "AddCanvasTableViewControllerSegue"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddEditCanvasItemNavigationController.entrySegueIdentifier() {
            let destinationNavigationController = segue.destinationViewController as! AddEditCanvasItemNavigationController
            let destination = destinationNavigationController.viewControllers[0] as! AddEditCanvasItemTableViewController
            destination.delegate = self
            
            // If the sender is a canvas item, set it up 
            // for edit
            if let canvasItemToEdit = sender as? CanvasItem {
                destination.canvasItemToEdit = canvasItemToEdit
            }
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    override func viewDidLoad() {
        self.tableView.separatorColor = UIColor.blackColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

        if let oldCanvas = self.canvasToEdit {
            self.title = "Edit Canvas"
            if let oldCanvasItems = oldCanvas.canvasItems {
                self.canvasItems = oldCanvasItems
            }
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonItemTapped:")
        } else {
            self.title = "Add Canvas"
            if let oldCanvas = self.existingCanvas {
                if let oldCanvasItems = oldCanvas.canvasItems {
                    self.canvasItems = oldCanvasItems
                }
            }
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
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        var error: String?
        var opName: String?
        var opXDimension: Int?
        var opYDimension: Int?
        
        opName = self.canvasNameTextField?.text
        opXDimension = self.xDimensionTextField?.integerValue()
        opYDimension = self.yDimensionTextField?.integerValue()
        
        if let name = opName {
            if let xDimension = opXDimension {
                if let yDimension = opYDimension {
                    if let oldCanvas = self.canvasToEdit {
                        oldCanvas.name = name
                        oldCanvas.xDimension = xDimension
                        oldCanvas.yDimension = yDimension
                        oldCanvas.canvasItems = self.canvasItems
                        
                        self.delegate.refreshPages()
                    } else {
                        let newCanvas = Canvas(
                            name: name,
                            xDimension: xDimension,
                            yDimension: yDimension,
                            canvasItems: self.canvasItems)
                        
                        self.delegate.addPage(newCanvas)
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)

                } else {
                    error = "Please enter a valid Y Dimension."
                }
            } else {
                error = "Please enter a valid X Dimension."
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
    
    func addCanvasItem(canvasItem: CanvasItem) {
        self.canvasItems.append(canvasItem)
        self.tableView.reloadData()
    }
    
    func refreshCanvasItems() {
        self.tableView.reloadData()
    }
    
    func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddEditCanvasTableViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case self.canvasItemsSection:
            if indexPath.row < self.canvasItems.count {
                // Show the edit canvas item view
                let canvasItem = self.canvasItems[indexPath.row]
                
                self.performSegueWithIdentifier(
                    AddEditCanvasItemNavigationController.entrySegueIdentifier(),
                    sender: canvasItem)
            } else if indexPath.row == self.canvasItems.count {
                self.performSegueWithIdentifier(
                    AddEditCanvasItemNavigationController.entrySegueIdentifier(),
                    sender: nil)
            }
        case self.canvasSizeSection:
            switch indexPath.row {
            case self.xDimensionRow: self.xDimensionTextField?.becomeFirstResponder()
            case self.yDimensionRow: self.yDimensionTextField?.becomeFirstResponder()
            default: break
            }
        case self.canvasNameSection: self.canvasNameTextField?.becomeFirstResponder()
        default: break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension AddEditCanvasTableViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        
        switch section {
        case self.canvasNameSection: header = "Name"
        case self.canvasSizeSection: header = "Size"
        case self.canvasItemsSection: header = "Canvas Items"
        default: break
        }
        
        return header
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.canvasNameSection: numberOfRows  = 1
        case self.canvasSizeSection: numberOfRows  = 2
        case self.canvasItemsSection: numberOfRows = self.canvasItems.count + 1
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.canvasNameSection:
            let canvasNameInputCell = tableView.dequeueReusableCellWithIdentifier(CanvasNameInputTableViewCell.cellIdentifier()) as! CanvasNameInputTableViewCell
            
            if let canvas = self.canvasToEdit {
                canvasNameInputCell.canvasNameTextField.text = canvas.name
            } else if let canvas = self.existingCanvas {
                canvasNameInputCell.canvasNameTextField.text = canvas.name
            }
            if let placeholder = canvasNameInputCell.canvasNameTextField.placeholder {
                canvasNameInputCell.canvasNameTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
            }
            self.canvasNameTextField = canvasNameInputCell.canvasNameTextField
            cell = canvasNameInputCell
        case self.canvasSizeSection:
            switch indexPath.row {
            case self.xDimensionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell!
                self.xDimensionTextField = textFieldDetailCell.textField
                textFieldDetailCell.textFieldLabel.text = "X Dimension"
                if let textField = textFieldDetailCell.textField {
                    textField.placeholder = "0"
                    if let placeholder = textField.placeholder {
                        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                    }
                    if let canvas = self.canvasToEdit {
                        textField.text = "\(canvas.xDimension)"
                    } else if let canvas = self.existingCanvas {
                        textField.text = "\(canvas.xDimension)"
                    }
                    self.xDimensionTextField = textField
                }
                
                cell = textFieldDetailCell
            case self.yDimensionRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell!
                self.yDimensionTextField = textFieldDetailCell.textField
                textFieldDetailCell.textFieldLabel.text = "Y Dimension"
                if let textField = textFieldDetailCell.textField {
                    textField.placeholder = "0"
                    if let placeholder = textField.placeholder {
                        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                    }
                    if let canvas = self.canvasToEdit {
                        textField.text = "\(canvas.yDimension)"
                    } else if let canvas = self.existingCanvas {
                        textField.text = "\(canvas.yDimension)"
                    }
                    self.yDimensionTextField = textField
                }
                
                
                cell = textFieldDetailCell
            default: break
            }
        case self.canvasItemsSection:
            if indexPath.row == self.canvasItems.count {
                // This cell is the last row
                cell = tableView.dequeueReusableCellWithIdentifier(AddCanvasItemTableViewCell.cellIdentifier()) as! AddCanvasItemTableViewCell
                
            } else {
                let canvasItemCell = tableView.dequeueReusableCellWithIdentifier(CanvasItemTableViewCell.cellIdentifier()) as! CanvasItemTableViewCell
                let canvasItem = self.canvasItems[indexPath.row]
                canvasItemCell.setupWithCanvasItem(canvasItem)
                cell = canvasItemCell
            }
        default: println("Error: Unknown table view section for Add/Edit Canvas")
        }
        
        return cell
    }
}