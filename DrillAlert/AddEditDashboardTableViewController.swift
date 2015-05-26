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
    
    var saveBarButtonItem: UIBarButtonItem!
    var activityBarButtonItem: UIBarButtonItem!
    
    var dashboardNameTextField: UITextField!
    
    func refreshPages() {
        self.tableView.reloadData()
    }
    
    func addPage(page: Page) {
        // Set the position to the latest one
        page.position = self.pages.count
        self.pages.append(page)
        self.tableView.reloadData()
    }
    
    func cancelBarButtonItemTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveDashboard(newDashboard: Dashboard) {
        Dashboard.saveDashboard(newDashboard,
            forUser: self.user,
            andWellbore: self.wellbore) { (error) -> Void in
            // If there is an error, show an alert.
            // Otherwise, dismiss this view.
            if let errorString = error {
                let alertController = UIAlertController(
                    title: "Error",
                    message: errorString,
                    preferredStyle: .Alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in }
                alertController.addAction(okayAction)
                self.hideActivityBarButton()
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.hideActivityBarButton()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
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
                    var newPages = self.pages
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
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorStyle = .None
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50.0))
        
        if let dashboard = dashboardToEdit {
            self.title = "Edit Dashboard"
            self.pages = dashboard.pages.sorted({ (page1, page2) -> Bool in
                return page1.position < page2.position
            })
        } else {
            self.title = "Add Dashboard"
            
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self, action: "cancelBarButtonItemTapped:")
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
    
    func addNewPageButtonTapped(sender: AnyObject) {
        self.presentChoosePanelTypeTableViewController()
    }
    
    func sortPagesButtonTapped(sender: AnyObject) {
        println("Should edit.")
    }
    
    func deleteDashboardButtonTapped(sender: UIButton) {
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
        let choosePageTypeNavigationController = storyboard.instantiateViewControllerWithIdentifier(
            ChoosePageTypeNavigationController.storyboardIdentifier()) as! ChoosePageTypeNavigationController
        // Get the first child of the navigation controller
        let choosePageTypeTableViewController = choosePageTypeNavigationController.viewControllers[0] as! ChoosePageTypeTableViewController
        
        // Set the required variables
        choosePageTypeTableViewController.user = self.user
        choosePageTypeTableViewController.wellbore = self.wellbore
        choosePageTypeTableViewController.delegate = self
        
        // Show the navigation controller
        self.presentViewController(choosePageTypeNavigationController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddEditCanvasNavigationController.editCanvasEntrySegueIdentifier() {
            if let navigationController = segue.destinationViewController as? AddEditCanvasNavigationController {
                if let viewController = navigationController.viewControllers[0] as? AddEditCanvasTableViewController {
                    if let canvas = sender as? Page {
                        viewController.canvasToEdit = canvas
                        viewController.delegate = self
                    }
                }
                
            }
        } else if segue.identifier == AddEditPlotNavigationController.editPlotEntrySegueIdentifier() {
            if let navigationController = segue.destinationViewController as? AddEditPlotNavigationController {
                if let viewController = navigationController.viewControllers[0] as? AddEditPlotTableViewController {
                    if let plot = sender as? Page {
                        viewController.plotToEdit = plot
                        viewController.delegate = self
                    }
                }
                
            }
        }
    }
    
    func presentEditCanvasViewController(page: Page) {
        self.performSegueWithIdentifier(AddEditCanvasNavigationController.editCanvasEntrySegueIdentifier(), sender: page)
    }
    
    func presentEditPlotViewController(page: Page) {
        self.performSegueWithIdentifier(AddEditPlotNavigationController.editPlotEntrySegueIdentifier(), sender: page)
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
            numberOfRows = self.pages.count
        case self.deleteDashboardSection:
            numberOfRows = 1
        default: break
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = ""
        
        if section == self.pagesSection {
            footer = ""
        }
        
        return footer
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat = 44.0
        if indexPath.section == self.pagesSection {
            rowHeight = 56.0
        }
        
        return rowHeight
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var rowHeight: CGFloat = 0
        
        if section == self.pagesSection {
            rowHeight = 80.0
        } else if section == self.dashboardNameSection || section == self.deleteDashboardSection {
            rowHeight = 34.0
        }
        
        return rowHeight
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var result: UIView?
        
        if section == self.pagesSection {
            result = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 80.0))
            result!.backgroundColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
            let addEditToolbarCell = tableView.dequeueReusableCellWithIdentifier(AddEditToolbarCell.cellIdentifier()) as! AddEditToolbarCell
            addEditToolbarCell.addButton.addTarget(self, action: "addNewPageButtonTapped:", forControlEvents: .TouchUpInside)
            addEditToolbarCell.editButton.addTarget(self, action: "sortPagesButtonTapped:", forControlEvents: .TouchUpInside)
            addEditToolbarCell.editButton.titleLabel?.text = "Sort"
            addEditToolbarCell.sectionLabel.text = "Pages"
            addEditToolbarCell.frame = CGRectMake(0, 0, tableView.frame.width, 80.0)
            addEditToolbarCell.backgroundColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
            addEditToolbarCell.sectionLabelBackground.backgroundColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
            result!.addSubview(addEditToolbarCell)
        } else if section == self.dashboardNameSection {
            result = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 34.0))
            let formSectionHeaderCell = tableView.dequeueReusableCellWithIdentifier(FormSectionHeaderCell.cellIdentifier()) as! FormSectionHeaderCell
            formSectionHeaderCell.sectionLabel.text = "Name"
            formSectionHeaderCell.sectionLabelBackground.backgroundColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
            formSectionHeaderCell.frame = CGRectMake(0, 0, tableView.frame.width, 34.0)
            result!.addSubview(formSectionHeaderCell)
        } else if section == self.deleteDashboardSection {
            result = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 34.0))
            let formSectionHeaderCell = tableView.dequeueReusableCellWithIdentifier(FormSectionHeaderCell.cellIdentifier()) as! FormSectionHeaderCell
            formSectionHeaderCell.sectionLabel.text = "Options"
            formSectionHeaderCell.sectionLabelBackground.backgroundColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
            formSectionHeaderCell.frame = CGRectMake(0, 0, tableView.frame.width, 34.0)
            result!.addSubview(formSectionHeaderCell)
        }
        
        return result
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var result: UIView?
        
        result = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 22.0))
        //result!.backgroundColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
        
        return result
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var result: CGFloat = 22.0
        return result
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
            /*
            else if indexPath.row == self.pages.count {
                // Add page row tapped
                self.presentChoosePanelTypeTableViewController()
            }
            */
            
        } else if indexPath.section == self.dashboardNameSection {
            self.dashboardNameTextField.becomeFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
            case self.dashboardNameSection:
                let dashboardNameCell = tableView.dequeueReusableCellWithIdentifier(DashboardNameInputTableViewCell.cellIdentifier()) as! DashboardNameInputTableViewCell
                self.dashboardNameTextField = dashboardNameCell.dashboardNameTextField
                if let placeholder = self.dashboardNameTextField.placeholder {
                    self.dashboardNameTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                }
                

                if let dashboard = self.dashboardToEdit {
                    // Set the textfield text to the name
                    dashboardNameCell.dashboardNameTextField.text = dashboard.name
                }
                
                cell = dashboardNameCell
            case pagesSection:
                let pageCell = tableView.dequeueReusableCellWithIdentifier(PanelTableViewCell.cellIdentifier()) as! PanelTableViewCell
                let page = self.pages[indexPath.row]
                
                if let label = pageCell.textLabel {
                    label.text = page.name
                }
                if let imageView = pageCell.imageView {
                    // Set the image
                    let imageSize = CGSize(width: 22.0, height: 22.0)
                    switch page.type {
                    case .Canvas:
                        if let image = UIImage(named: "canvas-icon-color") {
                            imageView.image = self.imageWithImage(image, scaledToSize: imageSize)
                        }
                    case .Plot:
                        if let image = UIImage(named: "plot-icon-color") {
                            imageView.image = self.imageWithImage(image, scaledToSize: imageSize)
                        }
                    case .Compass:
                        if let image = UIImage(named: "compass-icon-color") {
                            imageView.image = self.imageWithImage(image, scaledToSize: imageSize)
                        }
                        
                    default: break
                    }
                    
                    
                }
                
                cell = pageCell
                /*
                switch indexPath.row {
            
                case self.pages.count:
                    let addNewPageCell = tableView.dequeueReusableCellWithIdentifier(AddNewPageTableViewCell.cellIdentifier()) as! AddNewPageTableViewCell
                    var itemSize = CGSizeMake(22, 22);
                    
                    UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)

                    var imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                    if let imageView = addNewPageCell.imageView {
                        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
                    }
                    
                    UIGraphicsEndImageContext()

                    cell = addNewPageCell
            
                default:
                    
                }
                */
            case self.deleteDashboardSection:
                let deleteDashboardCell = tableView.dequeueReusableCellWithIdentifier(DeleteDashboardTableViewCell.cellIdentifier()) as! DeleteDashboardTableViewCell
                deleteDashboardCell.deleteDashboardButton.addTarget(self, action: "deleteDashboardButtonTapped:", forControlEvents: .TouchUpInside)
                cell = deleteDashboardCell
            default: break
        }
        
        return cell
    }
}