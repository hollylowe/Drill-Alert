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
    let numberOfSections = 2
    
    let canvasNameSection = 0
    let canvasNameRow = 0
    let canvasItemsSection = 1
    
    var canvasItems = Array<CanvasItem>()
    var canvasToEdit: Page?
    var existingCanvas: Page?
    
    var canvasNameTextField: UITextField!
    
    var delegate: AddEditDashboardTableViewController! 
    
    class func addCanvasFromExistingSegue() -> String {
        return "AddCanvasFromExistingSegue"
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
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        if let canvas = self.canvasToEdit {
            // Save already created Canvas
            let canvasNameIndexPath = NSIndexPath(
                forRow: self.canvasNameRow,
                inSection: self.canvasNameSection)
            
            let canvasNameCell = self.tableView.cellForRowAtIndexPath(canvasNameIndexPath) as! CanvasNameInputTableViewCell
            if let canvasName = canvasNameCell.canvasNameTextField.text {
                var items = Array<Item>()
                
                for canvasItem in self.canvasItems {
                    var jsFileName = ""
                    switch canvasItem.type {
                    case .Gauge: jsFileName = "Gauge.js"
                    case .NumberReadout: jsFileName = "NumberReadout.js"
                    default: break
                    }
                    
                    var newItem = Item(xPosition: 0, yPosition: 0, jsFileName: jsFileName)
                    items.append(newItem)
                }

                canvas.name = canvasName
                canvas.position = 0
                canvas.xDimension = 0
                canvas.yDimension = 0
                canvas.items = items
                
                self.delegate.refreshPages()
            }
        } else {
            // Create new canvas
            let canvasNameIndexPath = NSIndexPath(
                forRow: self.canvasNameRow,
                inSection: self.canvasNameSection)
            
            let canvasNameCell = self.tableView.cellForRowAtIndexPath(canvasNameIndexPath) as! CanvasNameInputTableViewCell
            if let canvasName = canvasNameCell.canvasNameTextField.text {
                // Create a visualization array with all the canvas items
                var items = Array<Item>()
                
                for canvasItem in self.canvasItems {
                    var jsFileName = ""
                    switch canvasItem.type {
                    case .Gauge: jsFileName = "Gauge.js"
                    case .NumberReadout: jsFileName = "NumberReadout.js"
                    default: break
                    }
                    
                    var newItem = Item(xPosition: 0, yPosition: 0, jsFileName: jsFileName)
                    items.append(newItem)
                }
                
                let newCanvas = Page(
                    name: canvasName,
                    position: 0,
                    xDimension: 0,
                    yDimension: 0,
                    items: items)
                newCanvas.type = .Canvas

                self.delegate.addPage(newCanvas)
                
            }
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        if let canvas = self.canvasToEdit {
            self.title = "Edit Canvas"
            for item in canvas.items {
                if let canvasItem = item as? CanvasItem {
                    self.canvasItems.append(canvasItem)
                }
            }
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonItemTapped:")
        } else {
            self.title = "Add Canvas"
            
            if let canvas = self.existingCanvas {
                for item in canvas.items {
                    if let canvasItem = item as? CanvasItem {
                        self.canvasItems.append(canvasItem)
                    }
                }
            }
        }
        
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        
        switch section {
        case self.canvasNameSection:
            header = ""
        case self.canvasItemsSection:
            header = "Canvas Items"
        default: break
        }
        
        return header
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.canvasNameSection:
            numberOfRows = 1
        case self.canvasItemsSection:
            // Add one for the "Add Canvas Item" row
            numberOfRows = self.canvasItems.count + 1
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == self.canvasItemsSection {
            if indexPath.row < self.canvasItems.count {
                // Show the edit canvas item view 
                let canvasItem = self.canvasItems[indexPath.row]
                
                self.performSegueWithIdentifier(AddEditCanvasItemNavigationController.entrySegueIdentifier(), sender: canvasItem)
            } else if indexPath.row == self.canvasItems.count {
                self.performSegueWithIdentifier(AddEditCanvasItemNavigationController.entrySegueIdentifier(), sender: nil)
            }
        } else if indexPath.section == self.canvasNameSection {
            if indexPath.row == self.canvasNameRow {
                self.canvasNameTextField.becomeFirstResponder()
            }
        }
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.canvasNameSection:
            let canvasNameInputCell = tableView.dequeueReusableCellWithIdentifier(CanvasNameInputTableViewCell.cellIdentifier()) as! CanvasNameInputTableViewCell
            self.canvasNameTextField = canvasNameInputCell.canvasNameTextField
            if let canvas = self.canvasToEdit {
                canvasNameInputCell.canvasNameTextField.text = canvas.name
            } else if let canvas = self.existingCanvas {
                canvasNameInputCell.canvasNameTextField.text = canvas.name
            }
            
            cell = canvasNameInputCell
            
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
    
    class func storyboardIdentifier() -> String {
        return "AddEditCanvasTableViewController"
    }
    
    
    class func addCanvasEntrySegueIdentifier() -> String {
        return "AddCanvasTableViewControllerSegue"
    }
}