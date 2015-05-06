//
//  AddEditLayoutTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditDashboardNavigationController: UINavigationController {
    class func storyboardIdentifier() -> String {
        return "AddEditDashboardNavigationController"
    }
}

class AddEditDashboardTableViewController: UITableViewController {
    var user: User!
    var wellbore: Wellbore!
    
    // This is only set if we're editing a layout
    var dashboardToEdit: Dashboard?
    
    // Table View Properties
    let dashboardNameSection = 0
    let pagesSection = 1
    let deleteDashboardSection = 2
    
    var pages = Array<Page>()
    
    let validSaveStatusCode = 200
    var saveBarButtonItem: UIBarButtonItem!
    var activityBarButtonItem: UIBarButtonItem!
    
    func addPage(page: Page) {
        self.pages.append(page)
        self.tableView.reloadData()
    }
    
    func cancelBarButtonItemTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveDashboard(newDashboard: Dashboard) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let URL = NSURL(string: "https://drillalert.azurewebsites.net/api/views") {
                var jsonString = newDashboard.toJSONString()
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
        let dashboardNameIndexPath = NSIndexPath(forRow: 0, inSection: self.dashboardNameSection)
        self.showActivityBarButton()
        
        if let cell = self.tableView.cellForRowAtIndexPath(dashboardNameIndexPath) as? DashboardNameInputTableViewCell {
            if let name = cell.dashboardNameTextField.text {
                if let newDashboard = self.dashboardToEdit {
                    newDashboard.name = name
                    newDashboard.pages = self.pages
                    
                    self.saveDashboard(newDashboard)
                } else {
                    let newDashboard = Dashboard(
                        name: name,
                        pages: self.pages,
                        userID: self.user.id,
                        wellboreID: self.wellbore.id)
                    self.saveDashboard(newDashboard)
                }
            }
        }
    }
    
    class func storyboardIdentifier() -> String {
        return "AddEditDashboardTableViewController"
    }
    
    class func editDashboardSegueIdentifier() -> String {
        return "EditDashboardTableViewControllerSegue"
    }
    
    func showActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.activityBarButtonItem, animated: true)
    }
    
    func hideActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
    }
    
    
    override func viewDidLoad() {
        if let dashboard = dashboardToEdit {
            self.title = "Edit Dashboard"
            self.pages = dashboard.pages
            
        } else {
            self.title = "Add Dashboard"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "Cancel",
                style: .Plain,
                target: self, action: "cancelBarButtonItemTapped:")
        }
        
        self.saveBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .Done,
            target: self,
            action: "saveButtonTapped:")
        
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
        if let dashboard = self.dashboardToEdit {
            if let id = dashboard.id {
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
    
    func presentEditCanvasViewController(page: Page) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewControllerWithIdentifier(AddEditCanvasTableViewController.storyboardIdentifier()) as! AddEditCanvasTableViewController
            viewController.canvasToEdit = page
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func presentEditPlotViewController(page: Page) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewControllerWithIdentifier(AddEditPlotTableViewController.storyboardIdentifier()) as! AddEditPlotTableViewController
            viewController.plotToEdit = page
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func presentEditCompassViewController(page: Page) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        if let navigationController = self.navigationController {
            let viewController = storyboard.instantiateViewControllerWithIdentifier(AddEditCompassTableViewController.storyboardIdentifier()) as! AddEditCompassTableViewController
            viewController.compassToEdit = page
            navigationController.pushViewController(viewController, animated: true)
        }
        
    }
}

extension AddEditDashboardTableViewController: UITableViewDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 2
        
        if self.dashboardToEdit != nil {
            numberOfSections = numberOfSections + 1
        }
        
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.dashboardNameSection:
            numberOfRows = 1
        case self.pagesSection:
            numberOfRows = self.pages.count + 1
        case self.deleteDashboardSection:
            numberOfRows = 1
        default: break
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        
        if section == self.pagesSection {
            header = "Pages"
        }
        
        return header
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = ""
        
        if section == self.pagesSection {
            footer = ""
        }
        
        return footer
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == self.pagesSection {
            if indexPath.row < self.pages.count {
                let panel = self.pages[indexPath.row]
                
                switch panel.type {
                case .Canvas: self.presentEditCanvasViewController(panel)
                case .Plot: self.presentEditPlotViewController(panel)
                case .Compass: self.presentEditCompassViewController(panel)
                default: println("Unknown page type.")
                }
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
            case self.dashboardNameSection:
                if let dashboard = self.dashboardToEdit {
                    let dashboardNameCell = tableView.dequeueReusableCellWithIdentifier(DashboardNameInputTableViewCell.cellIdentifier()) as! DashboardNameInputTableViewCell
                    dashboardNameCell.dashboardNameTextField.text = dashboard.name
                    cell = dashboardNameCell
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier(DashboardNameInputTableViewCell.cellIdentifier()) as! DashboardNameInputTableViewCell
                }
            case pagesSection:
                switch indexPath.row {
                case self.pages.count:
                    let addNewPanelCell = tableView.dequeueReusableCellWithIdentifier(AddNewPanelTableViewCell.cellIdentifier()) as! AddNewPanelTableViewCell
                    addNewPanelCell.addNewPanelButton.addTarget(self, action: "addNewPanelButtonTapped:", forControlEvents: .TouchUpInside)
                    cell = addNewPanelCell
                default:
                    let panelCell = tableView.dequeueReusableCellWithIdentifier(PanelTableViewCell.cellIdentifier()) as! PanelTableViewCell
                    let panel = self.pages[indexPath.row]
                    panelCell.panelNameLabel.text = panel.name
                    cell = panelCell
                }
            case self.deleteDashboardSection:
                let deleteDashboardCell = tableView.dequeueReusableCellWithIdentifier(DeleteDashboardTableViewCell.cellIdentifier()) as! DeleteDashboardTableViewCell
                deleteDashboardCell.deleteDashboardButton.addTarget(self, action: "deleteDashboardButtonTapped:", forControlEvents: .TouchUpInside)
                cell = deleteDashboardCell
            default: break
        }
        
        return cell
    }
}