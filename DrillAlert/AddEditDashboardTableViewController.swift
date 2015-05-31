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

class AddEditDashboardTableViewController: UITableViewController, UITextFieldDelegate {
    // If this view's isDisabled is set to true, 
    // then nothing can be interacted with on the
    // view.
    var isDisabled: Bool = false
    var user: User!
    var wellbore: Wellbore!
    var shouldShowConfirmationDialog = false
    // The dashboardToSave is the dashboard that
    // needs to be saved. It contains all of the user
    // changes to the either new dashboard or edited dashboard.
    var dashboardToSave: Dashboard?
    
    // The dashboard to edit is set when the user selects
    // a dashboard from the Edit Dashboards view.
    var dashboardToEdit: Dashboard?
    
    // Table View Properties
    let dashboardNameSection = 0
    let pagesSection = 1
    let pagesToolbarRow = 0
    let deleteDashboardSection = 2
    
    var pagesToolbarCell: AddEditToolbarCell!
    var deleteDashboardCell: DeleteDashboardTableViewCell?
    var saveBarButtonItem: UIBarButtonItem!
    var cancelBarButtonItem: UIBarButtonItem!
    var activityBarButtonItem: UIBarButtonItem!
    var dashboardNameTextField: UITextField!
    
    private func disableView() {
        self.isDisabled = true
        self.pagesToolbarCell.disable()
        self.deleteDashboardCell?.disable()
        self.saveBarButtonItem.enabled = false
        self.cancelBarButtonItem.enabled = false
        self.dashboardNameTextField.enabled = false
    }
    
    private func enableView() {
        self.isDisabled = false
        self.pagesToolbarCell.enable()
        self.deleteDashboardCell?.enable()
        self.saveBarButtonItem.enabled = true
        self.cancelBarButtonItem.enabled = true
        self.dashboardNameTextField.enabled = true
    }
    
    private func setupView() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorColor = UIColor(red: 0.112, green: 0.112, blue: 0.112, alpha: 1.0)
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 50.0))
        
        self.cancelBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .Plain,
            target: self, action: "cancelButtonTapped:")
        self.saveBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .Done,
            target: self,
            action: "saveButtonTapped:")
        if let saveButton = self.saveBarButtonItem {
            saveButton.tintColor = UIColor.SDIBlue()
        }
        
        let activityView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 25, 25))
        activityView.startAnimating()
        activityView.hidden = false
        activityView.color = UIColor.grayColor()
        activityView.sizeToFit()
        activityView.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
        
        self.activityBarButtonItem = UIBarButtonItem(customView: activityView)
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
        self.navigationItem.setLeftBarButtonItem(self.cancelBarButtonItem, animated: true)
    }

    func cancelButtonTapped(sender: AnyObject) {
        // If a user is editing a dashboard, but they 
        // then hit cancel, we need to discard any 
        // changes they may have made. 
        if let dashboard = self.dashboardToEdit {
            if self.shouldShowConfirmationDialog {
                let alert = UIAlertController(
                    title: "Are you sure?",
                    message: "Your changes to this dashboard will be lost.",
                    preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (alertAction) -> Void in
                    
                    // If we are canceling our changes to the dashboard,
                    // We need to update what is on the backend to what
                    // was there prior to the edit.
                    println("Reverting edited dashboard...")
                    self.showActivity()
                    Dashboard.saveDashboard(dashboard, forUser: self.user, andWellbore: self.wellbore, withCallback: { (error, dashboardID) -> Void in
                        self.hideActivity()
                        if error == nil {
                            println("Dashboard  successfully reverted.")
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            println("Dashboard not reverted. Error: \(error!)")
                        }
                    })
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        } else {
            // Otherwise, the user is canceling a Add Dashboard operation.
            // Since the dashboard has been saving on the backend as they
            // were making changes, we need to delete the dashboard (it was not
            // there before the Add Dashboard operation)
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
            
        }
        
        
    }
    
    func saveButtonTapped(sender: AnyObject) {
        // The user wants to save this dashboard.
        // At this point, the dashboard should be completely
        // updated on the backend with everything, besides 
        // the name.
        //
        
        if let dashboard = self.dashboardToSave {
            self.showActivityBarButton()
            if let name = self.dashboardNameTextField.text {
                dashboard.name = name
            }
            
            Dashboard.saveDashboard(dashboard,
                forUser: self.user,
                andWellbore: self.wellbore) { (error, dashboardID) -> Void in
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
        
    }
    
    func getNewestIDForLocalDashboard(localDashboard: Dashboard, andBackendDashboard backendDashboard: Dashboard) -> Int? {
        var newestID: Int?
        
        var filteredPages = backendDashboard.pages.filter({ (currentPage) -> Bool in
            for localPage in localDashboard.pages {
                if localPage.id != nil && localPage.id == currentPage.id {
                    // Don't return this page, because
                    // it already has a match with local and backend
                    return false
                }
            }
            
            return true
        })
        
        if filteredPages.count > 0 {
            var thePage = filteredPages[0]
            newestID = thePage.id
        }
        
        // If newest ID is still nil, then
        // then newest thing is an item.
        
        var totalBackendItems = Array<Item>()
        var totalLocalItems = Array<Item>()
        
        for page in backendDashboard.pages {
            switch page.type {
            case .Plot:
                if let tracks = page.tracks {
                    for track in tracks {
                        totalBackendItems.append(track)
                    }
                }
            case .Canvas:
                if let canvasItems = page.canvasItems {
                    for canvasItem in canvasItems {
                        totalBackendItems.append(canvasItem)
                    }
                }
            default: println("Unknown page type.")
            }
        }
        
        for page in localDashboard.pages {
            switch page.type {
            case .Plot:
                if let tracks = page.tracks {
                    for track in tracks {
                        totalLocalItems.append(track)
                    }
                }
            case .Canvas:
                if let canvasItems = page.canvasItems {
                    for canvasItem in canvasItems {
                        totalLocalItems.append(canvasItem)
                    }
                }
            default: println("Unknown page type.")
            }
        }
        
        
        var filteredItems = totalBackendItems.filter({ (currentItem) -> Bool in
            for localItem in totalLocalItems {
                if localItem.id != nil && localItem.id == currentItem.id {
                    // Don't return this page, because
                    // it already has a match with local and backend
                    return false
                }
            }
            
            return true
        })
        
        if filteredItems.count > 0 {
            var theItem = filteredItems[0]
            newestID = theItem.id
        }
        
        return newestID
    }
    
    // Everytime this is called is only after
    // one thing has been added to a dashboard,
    // wheter it is a page, a plot track, or a canvas item.
    // As such, we know that there is only one thing in the entirety
    // of the local dashboard that does not have an ID - but the 
    // backend dashboard does have an ID for this thing.
    func updateSavedDashboardToBackendWithCallback(callback: ((error: String?, newestID: Int?) -> Void)) {
        if let localDashboard = self.dashboardToSave {
            if let id = localDashboard.id {
                // Get the dashboard from the backend 
                if let backendDashboard = Dashboard.getDashboardWithID(id, forUser: self.user, andWellbore: self.wellbore) {
                    
                    var newestID = self.getNewestIDForLocalDashboard(localDashboard, andBackendDashboard: backendDashboard)
                    
                        self.dashboardToSave = backendDashboard
                        self.refreshPages()
                        callback(error: nil, newestID: newestID)
                        // self.tableView.reloadData()
                } else {
                    callback(error: "Error updating dashboard IDs: Could not retrieve backend dashboard.", newestID: nil)

                }
            } else {
                callback(error: "Error updating dashboard IDs: No ID on local dashboard.", newestID: nil)
            }
        } else {
            callback(error: "Error updating dashboard IDs: Local dashboard does not exist.", newestID: nil)
        }
    }
    
    // This should be called whenever a major change to the
    // dashboard occurs, like adding an item. By saving the 
    // dashboard continuously, we obtain access to item IDs, 
    // which allow us to save ItemCurves.
    func syncDashboardWithCallback(callback: ((error: String?, newestID: Int?) -> Void)) {
        self.shouldShowConfirmationDialog = true
        if let dashboard = self.dashboardToSave {
            // Show activity
            println("Syncing dashboard...")
            Dashboard.saveDashboard(dashboard,
                forUser: self.user,
                andWellbore: self.wellbore) { (error, savedDashboardID) -> Void in
                    // Hide Activity
                    if error != nil {
                        println("Error while saving dashboard:")
                        println(error!)
                        callback(error: error!, newestID: nil)
                    } else {
                        println("Saved dashboard.")
                        
                        if let id = savedDashboardID {
                            if dashboard.id == nil {
                                 dashboard.id = id
                            }
                            self.updateSavedDashboardToBackendWithCallback(callback)
                        } else {
                            callback(error: "Dashboard had no id.", newestID: nil)
                        }
                    }
            }
        }
    }

    override func viewDidLoad() {
        self.setupView()
        if let dashboard = dashboardToEdit {
            var sortedPages = dashboard.pages.sorted({ (page1, page2) -> Bool in
                return page1.position < page2.position
            })
            
            self.dashboardToSave = Dashboard(
                pages: sortedPages,
                userID: dashboard.userID,
                wellboreID: dashboard.wellboreID)
            self.dashboardToSave!.id = dashboard.id
            self.dashboardToSave!.name = dashboard.name
            
            self.title = "Edit Dashboard"
            
        } else {
            self.dashboardToSave = Dashboard(
                userID: self.user.id,
                wellboreID: self.wellbore.id)
            self.title = "Add Dashboard"
        }
        self.tableView.reloadData()
        super.viewDidLoad()
    }
    
    func addPage(page: Page) {
        // Set the position to the latest one
        if let dashboard = self.dashboardToSave {
            page.position = dashboard.pages.count
            dashboard.pages.append(page)
            self.tableView.reloadData()
        } else {
            println("Error: No dashboard to save when adding page.")
        }
    }
    
    func refreshPages() {
        println("Refreshing pages...")
        self.tableView.reloadData()
    }
    
    class func storyboardIdentifier() -> String {
        return "AddEditDashboardTableViewController"
    }
    
    class func editDashboardSegueIdentifier() -> String {
        return "EditDashboardTableViewControllerSegue"
    }
    
    func showActivity() {
        self.navigationItem.setLeftBarButtonItem(self.activityBarButtonItem, animated: true)
        self.disableView()
    }
    
    func hideActivity() {
        self.navigationItem.setLeftBarButtonItem(self.cancelBarButtonItem, animated: true)
        self.enableView()
    }
    
    func showActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.activityBarButtonItem, animated: true)
        self.disableView()
    }
    
    func hideActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
        self.enableView()
    }

    func addNewPageButtonTapped(sender: AnyObject) {
        self.presentChoosePanelTypeTableViewController()
    }
    
    func editPagesButtonTapped(sender: AnyObject) {
        self.editing = !self.editing
        if self.editing {
            self.pagesToolbarCell.editButton.setTitle("Done", forState: UIControlState.Normal)
        } else {
            self.pagesToolbarCell.editButton.setTitle("Edit", forState: UIControlState.Normal)
        }
    }
    
    func deleteDashboardButtonTapped(sender: UIButton) {

        let alertController = UIAlertController(title: "Delete dashboard?", message: "", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
            if let dashboard = self.dashboardToEdit {
                Dashboard.deleteDashboard(dashboard, forUser: self.user, withCallback: { (error) -> Void in
                    if error == nil {
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        let alert = UIAlertController(
                            title: "Error",
                            message: error,
                            preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
                
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentChoosePanelTypeTableViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the navigation controller
        let navController = storyboard.instantiateViewControllerWithIdentifier(
            ChoosePageTypeNavigationController.storyboardIdentifier()) as! ChoosePageTypeNavigationController
        let choosePageVC = navController.viewControllers[0] as! ChoosePageTypeTableViewController
        
        // Set the required variables
        choosePageVC.user = self.user
        choosePageVC.wellbore = self.wellbore
        choosePageVC.delegate = self
        
        // Sync the dashboard as it is now
        self.showActivityBarButton()
        self.syncDashboardWithCallback { (error, newestID) -> Void in
            if error == nil {
                // Show the navigation controller
                self.hideActivityBarButton()
                self.presentViewController(navController, animated: true, completion: nil)
            } else {
                self.hideActivityBarButton()
                println("Error saving dashboard: \(error!)")
            }
        }
        
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
                    if let plotIndex = sender as? Int {
                        viewController.plotToEditIndex = plotIndex
                        if let dashboard = self.dashboardToSave {
                            viewController.plotToEdit = dashboard.pages[plotIndex]
                        }
                    }
                    viewController.wellbore = self.wellbore
                    viewController.user = self.user
                    viewController.delegate = self
                }
                
            }
        }
    }
    
    func presentEditCanvasViewController(page: Page) {
        self.performSegueWithIdentifier(AddEditCanvasNavigationController.editCanvasEntrySegueIdentifier(), sender: page)
    }
    
    func presentEditPlotViewControllerForIndex(index: Int) {
        self.performSegueWithIdentifier(AddEditPlotNavigationController.editPlotEntrySegueIdentifier(), sender: index)
    }
    
}

extension AddEditDashboardTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var result = false
        
        if indexPath.section == self.pagesSection {
            if indexPath.row > 0 {
                result = true
            }
        }
        
        return result
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var result = false
        if indexPath.section == self.pagesSection {
            if indexPath.row > 0 {
                result = true
            }
        }
        return result
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        if let dashboard = self.dashboardToSave {
            if sourceIndexPath.section == self.pagesSection && destinationIndexPath.section == self.pagesSection {
                if sourceIndexPath.row > 0 && destinationIndexPath.row > 0 {
                    // Subtract one for the Add / Edit row
                    
                    var sourceIndex = sourceIndexPath.row - 1
                    var toIndex = destinationIndexPath.row - 1
                    var sourcePage = dashboard.pages[sourceIndex]
                    var toPage = dashboard.pages[toIndex]
                    
                    println("Source: " + sourcePage.name)
                    println("Destination: " + toPage.name)
                    
                    var tempPosition = sourcePage.position
                    sourcePage.position = toPage.position
                    toPage.position = tempPosition
                    
                    dashboard.pages.removeAtIndex(sourceIndex) // remove the source page
                    dashboard.pages.insert(sourcePage, atIndex: toIndex) // add it again
                }
            }
        }
        
    }
}

extension AddEditDashboardTableViewController: UITableViewDelegate {
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        var result = proposedDestinationIndexPath
        
        if sourceIndexPath.section == self.pagesSection && proposedDestinationIndexPath.section == self.pagesSection {
            if sourceIndexPath.row == 0 {
                // keep the add / edit toolbar at the top
                result = NSIndexPath(forRow: 0, inSection: self.pagesSection)
            } else if proposedDestinationIndexPath.row == 0 {
                result = NSIndexPath(forRow: 1, inSection: self.pagesSection)
            }
        } else if proposedDestinationIndexPath != self.pagesSection {
            result = sourceIndexPath
        }
        
        return result
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        var result: UITableViewCellEditingStyle = .None
        
        if indexPath.section == self.pagesSection {
            if indexPath.row > 0 {
                result = UITableViewCellEditingStyle.Delete
            }
        }
        
        return result
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 2
        
        if self.dashboardToEdit != nil {
            // Adding one for the delete dashboard section
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
            if let dashboard = self.dashboardToSave {
                numberOfRows = dashboard.pages.count + 1
            }
        case self.deleteDashboardSection:
            numberOfRows = 1
        default: break
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result: String?
        if section == self.pagesSection {
            result = "Pages"
        } else if section == self.dashboardNameSection {
            result = "Name"
        } else if section == self.deleteDashboardSection {
            result = "Options"
        }
        
        return result
    }
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = ""
        
        if section == self.pagesSection {
            footer = ""
        }
        
        return footer
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var rowHeight: CGFloat = 44.0
        if indexPath.section == self.pagesSection {
            if indexPath.row == self.pagesToolbarRow {
                rowHeight = 48.0
            } else {
                rowHeight = 56.0
            }
        }
        
        return rowHeight
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var rowHeight: CGFloat = 0
        
        if section == self.pagesSection || section == self.deleteDashboardSection {
            rowHeight = 40.0
        } else {
            rowHeight = 22.0
        }
        
        return rowHeight
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var result: UIView?
        
        result = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 22.0))
        if section == self.pagesSection {
            var borderView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 2.0))
            
            borderView.backgroundColor = UIColor(red: 0.221, green: 0.221, blue: 0.221, alpha: 1.0)
            result!.addSubview(borderView)
        }
        
        return result
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
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var result: CGFloat = 22.0
        return result
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !self.isDisabled {
            if let dashboard = self.dashboardToSave {
                if indexPath.section == self.pagesSection {
                    if indexPath.row == self.pagesToolbarRow {
                        
                    } else if indexPath.row <= dashboard.pages.count {
                        let pageIndex = indexPath.row - 1
                        let panel = dashboard.pages[pageIndex]
                        
                        switch panel.type {
                        case .Canvas: self.presentEditCanvasViewController(panel)
                        case .Plot: self.presentEditPlotViewControllerForIndex(pageIndex)
                        default: println("Unknown page type.")
                        }
                        
                    }
                    
                } else if indexPath.section == self.dashboardNameSection {
                    self.dashboardNameTextField.becomeFirstResponder()
                }
            }
        }
    }
    
    func createPageToolbarRow() -> AddEditToolbarCell {
        let addEditToolbarCell = tableView.dequeueReusableCellWithIdentifier(AddEditToolbarCell.cellIdentifier()) as! AddEditToolbarCell
        addEditToolbarCell.addButton.addTarget(
            self,
            action: "addNewPageButtonTapped:",
            forControlEvents: .TouchUpInside)
        
        addEditToolbarCell.editButton.addTarget(self, action: "editPagesButtonTapped:", forControlEvents: .TouchUpInside)
        addEditToolbarCell.frame = CGRectMake(0, 0, tableView.frame.width, 80.0)
        addEditToolbarCell.backgroundColor = UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
        self.pagesToolbarCell = addEditToolbarCell
        return addEditToolbarCell
    }
    
    func createPageCellWithPage(page: Page) -> PanelTableViewCell {
        let pageCell = tableView.dequeueReusableCellWithIdentifier(PanelTableViewCell.cellIdentifier()) as! PanelTableViewCell
        
        if let label = pageCell.textLabel {
            label.text = page.name
        }
        if let imageView = pageCell.imageView {
            let imageSize = CGSize(width: 22.0, height: 22.0)

            switch page.type {
            case .Canvas:
                imageView.image = UIImage(named: "canvas-icon-color")?.imageWithImageSize(imageSize)
            case .Plot:
                imageView.image = UIImage(named: "plot-icon-color")?.imageWithImageSize(imageSize)
            case .Compass:
                imageView.image = UIImage(named: "compass-icon-color")?.imageWithImageSize(imageSize)
                
            default: break
            }
            
            
        }
        
        return pageCell
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if let dashboard = self.dashboardToSave {
            dashboard.name = textField.text
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
            case self.dashboardNameSection:
                let dashboardNameCell = tableView.dequeueReusableCellWithIdentifier(DashboardNameInputTableViewCell.cellIdentifier()) as! DashboardNameInputTableViewCell
                self.dashboardNameTextField = dashboardNameCell.dashboardNameTextField
                if let placeholder = self.dashboardNameTextField.placeholder {
                    self.dashboardNameTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
                }
                self.dashboardNameTextField.delegate = self
                
                if let name = self.dashboardToSave?.name {
                    dashboardNameCell.dashboardNameTextField.text = name
                }
                
                cell = dashboardNameCell
            case pagesSection:
                if let dashboard = self.dashboardToSave {
                    if indexPath.row == self.pagesToolbarRow {
                        cell = self.createPageToolbarRow()
                    } else if indexPath.row <= dashboard.pages.count {
                        let page = dashboard.pages[indexPath.row - 1]
                        cell = self.createPageCellWithPage(page)
                    }
                }
            case self.deleteDashboardSection:
                let newDeleteDashboardCell = tableView.dequeueReusableCellWithIdentifier(DeleteDashboardTableViewCell.cellIdentifier()) as! DeleteDashboardTableViewCell
                newDeleteDashboardCell.deleteDashboardButton.addTarget(self, action: "deleteDashboardButtonTapped:", forControlEvents: .TouchUpInside)
                self.deleteDashboardCell = newDeleteDashboardCell
                cell = deleteDashboardCell
            default: break
        }
        
        return cell
    }
}