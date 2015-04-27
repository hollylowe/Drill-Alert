//
//  AddEditLayoutTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditLayoutNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String {
        return "AddEditLayoutNavigationController"
    }
}

class AddEditLayoutTableViewController: UITableViewController {
    var user: User!
    var wellbore: Wellbore!
    
    // This is only set if we're editing a layout
    var layoutToEdit: Layout?
    
    // Table View Properties
    let layoutNameSection = 0
    let panelsSection = 1
    let deleteLayoutSection = 2
    
    var panels = Array<Panel>()
    
    let validSaveStatusCode = 200
    var saveBarButtonItem: UIBarButtonItem!
    var activityBarButtonItem: UIBarButtonItem!
    
    func addPanel(panel: Panel) {
        self.panels.append(panel)
        self.tableView.reloadData()
    }
    
    func cancelBarButtonItemTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveLayout(newLayout: Layout) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let URL = NSURL(string: "https://drillalert.azurewebsites.net/api/views") {
                var jsonString = newLayout.toJSONString()
                println("Json: ")
                println(jsonString)
                if let postData = jsonString.dataUsingEncoding(NSASCIIStringEncoding) {
                    let postLength = String(postData.length)
                    
                    let request = NSMutableURLRequest(URL: URL)
                    request.HTTPMethod = "POST"
                    request.HTTPBody = postData
                    request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                    
                    println("About to send...")
                    let task = self.user.session.session!.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            println("Send view completed")
                            if let HTTPResponse = response as? NSHTTPURLResponse {
                                let statusCode = HTTPResponse.statusCode
                                if statusCode != self.validSaveStatusCode {
                                    let alertController = UIAlertController(title: "Error", message: "Unable to save Layout (\(statusCode)).", preferredStyle: UIAlertControllerStyle.Alert)
                                    
                                    let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
                                        
                                    }
                                    alertController.addAction(okayAction)
                                    
                                    self.hideActivityBarButton()
                                    self.presentViewController(alertController, animated: true, completion: nil)
                                } else {
                                    println("Response: ")
                                    println(response)
                                    println("Data:")
                                    println(NSString(data: data, encoding: NSASCIIStringEncoding))
                                    self.hideActivityBarButton()
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                }
                            }
                            
                        })
                    })
                    
                    task.resume()
                }
            }
        })
    }
    
    func saveButtonTapped(sender: AnyObject) {
        let layoutNameIndexPath = NSIndexPath(forRow: 0, inSection: self.layoutNameSection)
        self.showActivityBarButton()
        
        if let cell = self.tableView.cellForRowAtIndexPath(layoutNameIndexPath) as? LayoutNameInputTableViewCell {
            if let name = cell.layoutNameTextField.text {
                if let newLayout = self.layoutToEdit {
                    newLayout.name = name
                    newLayout.panels = self.panels
                    
                    self.saveLayout(newLayout)
                } else {
                    let newLayout = Layout(
                        name: name,
                        panels: self.panels,
                        userID: self.user.id,
                        wellboreID: self.wellbore.id)
                    self.saveLayout(newLayout)
                }
            }
        }
    }
    
    class func storyboardIdentifier() -> String {
        return "AddEditLayoutTableViewController"
    }
    
    class func editLayoutSegueIdentifier() -> String {
        return "EditLayoutTableViewControllerSegue"
    }
    
    func showActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.activityBarButtonItem, animated: true)
    }
    
    func hideActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
    }
    
    
    override func viewDidLoad() {
        if let layout = layoutToEdit {
            self.title = "Edit Layout"
            self.panels = layout.panels
            
        } else {
            self.title = "Add Layout"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBarButtonItemTapped:")
        }
        
        self.saveBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Done, target: self, action: "saveButtonTapped:")
        
        let activityView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 25, 25))
        activityView.startAnimating()
        activityView.hidden = false
        activityView.color = UIColor.grayColor()
        activityView.sizeToFit()
        activityView.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
        
        self.activityBarButtonItem = UIBarButtonItem(customView: activityView)
        
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
        
        super.viewDidLoad()
    }
    
    func addNewPanelButtonTapped(sender: UIButton) {
        self.presentChoosePanelTypeTableViewController()
    }
    
    func deleteLayoutButtonTapped(sender: UIButton) {
        if let layout = self.layoutToEdit {
            if let id = layout.id {
                println("Deleting Layout #\(id)")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    if let URL = NSURL(string: "https://drillalert.azurewebsites.net/api/views/\(id)") {
                        let request = NSMutableURLRequest(URL: URL)
                        request.HTTPMethod = "DELETE"
                        
                        let task = self.user.session.session!.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                println("Data: ")
                                println(NSString(data: data, encoding: NSASCIIStringEncoding))
                                println("Response: ")
                                println(response)
                                println("Error: ")
                                println(error)
                                if let navigationController = self.navigationController {
                                    navigationController.popViewControllerAnimated(true)
                                }
                            })
                        })
                        
                        task.resume()
                    }
                })
            }
        }
    }
    
    func presentChoosePanelTypeTableViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        let choosePanelTypeNavigationController = storyboard.instantiateViewControllerWithIdentifier(
            ChoosePanelTypeNavigationController.storyboardIdentifier()) as! ChoosePanelTypeNavigationController
        // Get the first child of the navigation controller
        let choosePanelTypeTableViewController = choosePanelTypeNavigationController.viewControllers[0] as! ChoosePanelTypeTableViewController
        
        // Set the required variables
        choosePanelTypeTableViewController.wellbore = self.wellbore
        choosePanelTypeTableViewController.user = self.user
        choosePanelTypeTableViewController.delegate = self
        
        // Show the navigation controller
        self.presentViewController(choosePanelTypeNavigationController, animated: true, completion: nil)
    }
    
    func presentEditCanvasViewController(panel: Panel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewControllerWithIdentifier(AddEditCanvasTableViewController.storyboardIdentifier()) as! AddEditCanvasTableViewController
            viewController.canvasToEdit = panel
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func presentEditPlotViewController(panel: Panel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewControllerWithIdentifier(AddEditPlotTableViewController.storyboardIdentifier()) as! AddEditPlotTableViewController
            viewController.plotToEdit = panel
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func presentEditCompassViewController(panel: Panel) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewControllerWithIdentifier(AddEditCompassTableViewController.storyboardIdentifier()) as! AddEditCompassTableViewController
            viewController.compassToEdit = panel
            navigationController.pushViewController(viewController, animated: true)
        }
        
    }
}

extension AddEditLayoutTableViewController: UITableViewDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 2
        
        if self.layoutToEdit != nil {
            numberOfSections = numberOfSections + 1
        }
        
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.layoutNameSection:
            numberOfRows = 1
        case self.panelsSection:
            numberOfRows = self.panels.count + 1
        case self.deleteLayoutSection:
            numberOfRows = 1
        default: break
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        
        if section == panelsSection {
            header = "Panels"
        }
        
        return header
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = ""
        
        if section == self.panelsSection {
            footer = "A panel is one of the pages you see when viewing a wellbore's visuals. A panel can contain multiple visualizations."
        }
        
        return footer
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == self.panelsSection {
            if indexPath.row < self.panels.count {
                let panel = self.panels[indexPath.row]
                
                switch panel.type {
                case .Canvas: self.presentEditCanvasViewController(panel)
                case .Plot: self.presentEditPlotViewController(panel)
                case .Compass: self.presentEditCompassViewController(panel)
                default: println("Unknown panel type.")
                }
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
            case layoutNameSection:
                if let layout = self.layoutToEdit {
                    let layoutNameCell = tableView.dequeueReusableCellWithIdentifier(LayoutNameInputTableViewCell.cellIdentifier()) as! LayoutNameInputTableViewCell
                    layoutNameCell.layoutNameTextField.text = layout.name
                    cell = layoutNameCell
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier(LayoutNameInputTableViewCell.cellIdentifier()) as! LayoutNameInputTableViewCell
                }
            case panelsSection:
                switch indexPath.row {
                case self.panels.count:
                    let addNewPanelCell = tableView.dequeueReusableCellWithIdentifier(AddNewPanelTableViewCell.cellIdentifier()) as! AddNewPanelTableViewCell
                    addNewPanelCell.addNewPanelButton.addTarget(self, action: "addNewPanelButtonTapped:", forControlEvents: .TouchUpInside)
                    cell = addNewPanelCell
                default:
                    let panelCell = tableView.dequeueReusableCellWithIdentifier(PanelTableViewCell.cellIdentifier()) as! PanelTableViewCell
                    let panel = self.panels[indexPath.row]
                    panelCell.panelNameLabel.text = panel.name
                    cell = panelCell
                }
            case self.deleteLayoutSection:
                let deleteLayoutCell = tableView.dequeueReusableCellWithIdentifier(DeleteLayoutTableViewCell.cellIdentifier()) as! DeleteLayoutTableViewCell
                deleteLayoutCell.deleteLayoutButton.addTarget(self, action: "deleteLayoutButtonTapped:", forControlEvents: .TouchUpInside)
                cell = deleteLayoutCell
            default: break
        }
        
        return cell
    }
}