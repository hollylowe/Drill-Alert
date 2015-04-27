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
    let numberOfSections = 3
    
    let canvasItemNameSection = 0
    let canvasItemTypeSection = 1
    let canvasItemDataSourceSection = 2
    
    var canvasItemToEdit: CanvasItem?
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
    
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
            cell = tableView.dequeueReusableCellWithIdentifier(CanvasItemNameInputTableViewCell.cellIdentifier()) as! CanvasItemNameInputTableViewCell
        case self.canvasItemTypeSection:
            let canvasItemType = CanvasItemType.allValues[indexPath.row]
            let canvasItemTypeCell = tableView.dequeueReusableCellWithIdentifier(CanvasItemTypeTableViewCell.cellIdentifier()) as! CanvasItemTypeTableViewCell
            canvasItemTypeCell.setupWithCanvasItemType(canvasItemType)
            cell = canvasItemTypeCell
        case self.canvasItemDataSourceSection:
            let canvasItemDataSource = CanvasItemDataSource.allValues[indexPath.row]
            let canvasItemDataSourceCell = tableView.dequeueReusableCellWithIdentifier(CanvasItemDataSourceTableViewCell.cellIdentifier()) as! CanvasItemDataSourceTableViewCell
            canvasItemDataSourceCell.setupWithCanvasItemDataSource(canvasItemDataSource)
            cell = canvasItemDataSourceCell
        default: break
        }
        
        return cell
    }
}