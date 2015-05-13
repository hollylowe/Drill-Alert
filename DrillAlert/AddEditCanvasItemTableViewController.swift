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
    
    var delegate: AddEditCanvasTableViewController!
    
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    var canvasItemNameCell: CanvasItemNameInputTableViewCell?
    let numberOfSections = 3
    let canvasItemNameSection = 0
    let canvasItemTypeSection = 1
    let canvasItemDataSourceSection = 2
    
    var selectedTypeIndex = 0;
    var selectedDataSourceIndex = 0;
    var canvasItemToEdit: CanvasItem?
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        
        if let cell = self.canvasItemNameCell {
            if let name = cell.canvasItemNameTextField.text {
                
                // TODO: Replace with real values from server
                let type = CanvasItemType.allValues[self.selectedTypeIndex]
                let dataSource = CanvasItemDataSource.allValues[self.selectedDataSourceIndex]
                
                if let canvasItem = self.canvasItemToEdit {
                    canvasItem.xPosition = 0
                    canvasItem.yPosition = 0
                    canvasItem.curveIDs = [0]
                    canvasItem.type = type
                    canvasItem.dataSource = dataSource
                    canvasItem.name = name
                    
                    self.delegate.refreshCanvasItems()
                } else {
                    // TODO: Canvas Item xPostion, yPosition, and Curve ID
                    let newCanvasItem = CanvasItem(
                        xPosition: 0,
                        yPosition: 0,
                        curveID: 0,
                        type: type,
                        dataSource: dataSource,
                        name: name)
                    
                    self.delegate.addCanvasItem(newCanvasItem)
                }
                self.dismissViewControllerAnimated(true, completion: nil)

            }
        }
        
       
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        if let canvasItem = self.canvasItemToEdit {
            self.title = "Edit Canvas Item"
        } else {
            self.title = "Add Canvas Item"
        }
        
        super.viewDidLoad()
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
        case self.canvasItemTypeSection: numberOfRows = CanvasItemType.allValues.count
        case self.canvasItemDataSourceSection: numberOfRows = CanvasItemDataSource.allValues.count
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        switch section {
        case self.canvasItemNameSection: title = ""
        case self.canvasItemTypeSection: title = "Type"
        case self.canvasItemDataSourceSection: title = "Data Source"
        default: title = ""
        }
        
        return title
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.canvasItemNameSection:
            self.canvasItemNameCell = tableView.dequeueReusableCellWithIdentifier(CanvasItemNameInputTableViewCell.cellIdentifier()) as? CanvasItemNameInputTableViewCell
            
            if let canvas = self.canvasItemToEdit {
                self.canvasItemNameCell!.canvasItemNameTextField.text = canvas.name
            }
            
            cell = self.canvasItemNameCell

        case self.canvasItemTypeSection:
            let canvasItemType = CanvasItemType.allValues[indexPath.row]
            let canvasItemTypeCell = tableView.dequeueReusableCellWithIdentifier(CanvasItemTypeTableViewCell.cellIdentifier()) as! CanvasItemTypeTableViewCell
            
            if let canvasItem = self.canvasItemToEdit {
                if canvasItemType == canvasItem.type {
                    canvasItemTypeCell.accessoryType = .Checkmark
                }
            }
            
            canvasItemTypeCell.setupWithCanvasItemType(canvasItemType)
            cell = canvasItemTypeCell
        case self.canvasItemDataSourceSection:
            let canvasItemDataSource = CanvasItemDataSource.allValues[indexPath.row]
            let canvasItemDataSourceCell = tableView.dequeueReusableCellWithIdentifier(CanvasItemDataSourceTableViewCell.cellIdentifier()) as! CanvasItemDataSourceTableViewCell
            if let canvasItem = self.canvasItemToEdit {
                if canvasItemDataSource == canvasItem.dataSource {
                    canvasItemDataSourceCell.accessoryType = .Checkmark
                }
            }
            
            canvasItemDataSourceCell.setupWithCanvasItemDataSource(canvasItemDataSource)
            cell = canvasItemDataSourceCell
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
        
        if (indexPath.section != self.canvasItemNameSection) {
            // Add a check mark to the row
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                self.resetAccessoryTypesForSection(indexPath.section)
                cell.accessoryType = .Checkmark
            }
            
            if indexPath.section == self.canvasItemTypeSection {
                self.selectedTypeIndex = indexPath.row
            } else if indexPath.section == self.canvasItemDataSourceSection {
                self.selectedDataSourceIndex = indexPath.row
            }
        } else {
            if let nameCell = self.canvasItemNameCell {
                nameCell.becomeFirstResponder()
            }
        }
        
    }
}