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
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        if let canvas = self.canvasToEdit {
            // Save already created Canvas
            let canvasNameIndexPath = NSIndexPath(
                forRow: self.canvasNameRow,
                inSection: self.canvasNameSection)
            
            let canvasNameCell = self.tableView.cellForRowAtIndexPath(canvasNameIndexPath) as! CanvasNameInputTableViewCell
            if let canvasName = canvasNameCell.canvasNameTextField.text {
                println(canvasName)
            }
        } else {
            // Create new canvas
            let canvasNameIndexPath = NSIndexPath(
                forRow: self.canvasNameRow,
                inSection: self.canvasNameSection)
            
            let canvasNameCell = self.tableView.cellForRowAtIndexPath(canvasNameIndexPath) as! CanvasNameInputTableViewCell
            if let canvasName = canvasNameCell.canvasNameTextField.text {
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        if let canvas = self.canvasToEdit {
            self.title = "Edit Canvas"
        } else {
            self.title = "Add Canvas"
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.canvasNameSection:
            cell = tableView.dequeueReusableCellWithIdentifier(CanvasNameInputTableViewCell.cellIdentifier()) as! CanvasNameInputTableViewCell
        case self.canvasItemsSection:
            if indexPath.row == self.canvasItems.count {
                // This cell is the last row
                cell = tableView.dequeueReusableCellWithIdentifier(AddCanvasItemTableViewCell.cellIdentifier()) as! AddCanvasItemTableViewCell

            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(CanvasItemTableViewCell.cellIdentifier()) as! CanvasItemTableViewCell
            }
        default: println("Error: Unknown table view section for Add/Edit Canvas")
        }
        
        return cell
    }
    
    class func storyboardIdentifier() -> String {
        return "AddEditCanvasTableViewController"
    }
}