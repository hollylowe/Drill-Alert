import Foundation
import UIKit

class AddEditPlotTableViewController: UITableViewController {
    
    // Implicit, set by the previous view controller
    var isDisabled = false
    var delegate: AddEditDashboardTableViewController!
    var wellbore: Wellbore!
    var user: User!
    
    // Set if we're editing a plot
    var plotToEdit: Page?
    var dashboardPriorToEdit: Dashboard?
    var plotToEditIndex: Int?
    var plotToSave: Page?
    var shouldShowConfirmationDialog = false
    // Set if we're adding a plot from existing
    var existingPlot: Page?
    
    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    // Sections
    let numberOfSections            = 3
    let plotNameSection             = 0
    let plotTracksSection           = 2
    let plotPropertiesSection       = 1
    
    // Rows
    let plotPropertiesNumberOfRows  = 2
    let xDimensionRow = 0
    let yDimensionRow = 1
    
    // Dynamic TextFields
    var plotNameTextField: UITextField?
    var xDimensionTextField: UITextField?
    var yDimensionTextField: UITextField?
    
    var activityBarButtonItem: UIBarButtonItem!
    var saveBarButtonItem: UIBarButtonItem!
    
    private func disableView() {
        self.isDisabled = true
        self.plotNameTextField?.enabled = false
        self.xDimensionTextField?.enabled = false
        self.yDimensionTextField?.enabled = false
        
    }
    
    private func enableView() {
        self.isDisabled = false
        self.plotNameTextField?.enabled = true
        self.xDimensionTextField?.enabled = true
        self.yDimensionTextField?.enabled = true
    }
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.tableView.separatorColor = UIColor.blackColor()
        
        let activityView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 25, 25))
        activityView.startAnimating()
        activityView.hidden = false
        activityView.color = UIColor.grayColor()
        activityView.sizeToFit()
        activityView.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
        
        self.activityBarButtonItem = UIBarButtonItem(customView: activityView)
        
        if let plot = self.plotToEdit {
            self.title = "Edit Plot"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonItemTapped:")

            if let id = plot.id {
                if let tracks = plot.tracks {
                    self.plotToSave = Page(
                        id: id,
                        name: plot.name,
                        xDimension: plot.xDimension,
                        yDimension: plot.yDimension,
                        tracks: tracks)
                } else {
                    self.plotToSave = Page(
                        id: id,
                        name: plot.name,
                        xDimension: plot.xDimension,
                        yDimension: plot.yDimension,
                        tracks: [Track]())
                    println("Warning: Plot to edit has no tracks.")
                }
            } else {
                if let tracks = plot.tracks {
                    self.plotToSave = Page(
                        name: plot.name,
                        xDimension: plot.xDimension,
                        yDimension: plot.yDimension,
                        tracks: tracks)

                } else {
                    self.plotToSave = Page(
                        name: plot.name,
                        xDimension: plot.xDimension,
                        yDimension: plot.yDimension,
                        tracks: [Track]())
                    println("Warning: Plot to edit has no tracks.")

                }
                
                println("Error: Plot to edit has no ID.")
            }
        } else {
            self.title = "Add Plot"
            if let plot = self.existingPlot {
                if let tracks = plot.tracks {
                    self.plotToSave = Page(
                        name: plot.name,
                        xDimension: plot.xDimension,
                        yDimension: plot.yDimension,
                        tracks: tracks)
                } else {
                    self.plotToSave = Page(name: plot.name, xDimension: plot.xDimension, yDimension: plot.yDimension, tracks: [Track]())
                }
            } else {
                self.plotToSave = Page(name: "", xDimension: 0, yDimension: 0, tracks: [Track]())
            }
        }
        
        self.saveBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .Done,
            target: self,
            action: "saveButtonTapped:")
        if let saveButton = self.saveBarButtonItem {
            saveButton.tintColor = UIColor.SDIBlue()
        }
        
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
        super.viewDidLoad()
    }
    func showActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.activityBarButtonItem, animated: true)
        self.disableView()
    }
    
    func hideActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.saveBarButtonItem, animated: true)
        self.enableView()
    }
    
    // Called when user taps the Save button.
    func syncPlotWithDashboardWithCallback(callback: ((error: String?, newestID: Int?) -> Void)) {
        self.shouldShowConfirmationDialog = true
        // If the user is editing a plot, 
        // we need to swap the new plot with the new changes
        // with the old plot that is currently in the dashboardToSave
        // variable.
        //
        // If the user is adding a new plot,
        // we just add the plot to the dashboard.
        //
        // Then, we call syncDashboard. This will save the dashboard
        // to the backend as it is now, with the edited plot or added plot. 
        if let newPlot = self.plotToSave {
            if let dashboard = self.delegate.dashboardToSave {
                if let oldPlot = self.plotToEdit {
                    if let oldPlotIndex = self.plotToEditIndex {
                        if oldPlotIndex < dashboard.pages.count {
                            dashboard.swapPageAtIndex(oldPlotIndex, withPage: newPlot)
                        } else {
                            callback(error: "Error: Page to edit index was not less than the dashboard pages count.", newestID: nil)
                        }
                    } else {
                        callback(error: "Error: Had plot to edit, but no index.", newestID: nil)
                    }
                } else {
                    if let id = newPlot.id {
                        dashboard.updatePage(newPlot)
                    } else {
                        dashboard.addPage(newPlot)
                    }
                }
                
                self.delegate.syncDashboardWithCallback({ (error, newestID) -> Void in
                   
                    if error == nil {
                        callback(error: nil, newestID: newestID)
                    } else {
                        callback(error: "Error syncing dashboard: \(error!).", newestID: nil)
                    }
                })
                
            } else {
                callback(error: "Error: No dashboard to save.", newestID: nil)
            }
        } else {
            callback(error: "Error: No plot to save.", newestID: nil)
        }
        
    }
    
    class func addPlotFromExistingSegue() -> String {
        return "AddPlotFromExistingSegue"
    }
    
    // This saves the current plot's properties
    // (all the textfields) and then posts it to 
    // the backend.
    func savePlotWithCallback(callback: ((error: String?, newestID: Int?) -> Void)) {
        var error: String?
        var opName: String?
        var opXDimension: Int?
        var opYDimension: Int?
        
        if let textField = self.plotNameTextField {
            if !textField.text.isEmpty {
                opName = textField.text
            }
        }
        
        opXDimension = self.xDimensionTextField?.integerValue()
        opYDimension = self.yDimensionTextField?.integerValue()
        
        if let name = opName {
            if let xDimension = opXDimension {
                if let yDimension = opYDimension {
                    if let plot = self.plotToSave {
                        plot.name = name
                        plot.xDimension = xDimension
                        plot.yDimension = yDimension
                        // tracks should be updated already
                        self.syncPlotWithDashboardWithCallback({ (error, newestID) -> Void in
                            if error == nil {
                                if plot.id == nil {
                                    // If the newPlot did not have an ID already, then it
                                    // is  the item with the newest id.
                                    self.plotToSave?.id = newestID
                                    callback(error: nil, newestID: nil)
                                } else {
                                    callback(error: nil, newestID: newestID)
                                }
                                
                            } else {
                                callback(error: error!, newestID: nil)
                            }
                        })
                    } else {
                        callback(error: "Error: No Plot To Save.", newestID: nil)
                    }
                } else {
                    callback(error: "Please enter a valid Y Dimension.", newestID: nil)
                }
            } else {
                callback(error: "Please enter a valid X Dimension.", newestID: nil)
            }
        } else {
            callback(error: "Please enter a name.", newestID: nil)
        }
        
        
    }
    
    func saveButtonTapped(sender: UIBarButtonItem) {
        self.showActivityBarButton()
        self.savePlotWithCallback { (error, newestID) -> Void in
            self.hideActivityBarButton()
            if (error != nil) {
                let alertController = UIAlertController(
                    title: "Error",
                    message: error!,
                    preferredStyle: .Alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in
                    
                }
                
                alertController.addAction(okayAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    
    func addTrack(track: Track) {
        if let plot = self.plotToSave {
            if plot.tracks == nil {
                println("Warning: Plot tracks were nil, creating a new array.")
                plot.tracks = Array<Track>()
            }
            
            plot.tracks!.append(track)
            self.tableView.reloadData()
        } else {
            println("Error: Attempted to add track to plot, however there was no plot to save.")
        }
    }
    
    func swapTrackAtIndex(index: Int, withTrack track: Track) {
        if let plot = self.plotToSave {
            if plot.tracks != nil {
                plot.tracks!.removeAtIndex(index)
                plot.tracks!.append(track)
                self.tableView.reloadData()
            } else {
                println("Error: Tracks were nil when attempting swap.")
            }
        } else {
            println("Error: Plot to save was nil when attempting swap.")
        }
    }
    
    class func addPlotEntrySegueIdentifier() -> String {
        return "AddPlotTableViewControllerSegue"
    }
    
    class func storyboardIdentifier() -> String! {
        return "AddEditPlotTableViewController"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == AddEditTrackNavigationController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! AddEditTrackNavigationController
            let viewController = destination.viewControllers[0] as! AddEditTrackTableViewController
            
            viewController.addEditPlotDelegate = self
            viewController.wellbore = self.wellbore
            viewController.user = self.user
            if let trackIndex = sender as? Int {
                viewController.trackToEditIndex = trackIndex
                if let plot = self.plotToSave {
                    if let tracks = plot.tracks {
                        viewController.trackToEdit = tracks[trackIndex]
                    }
                }
                
            }
            
            
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        if !self.isDisabled {
            // If a user is editing a plot, but they
            // then hit cancel, we need to discard any
            // changes they may have made.
            if let oldPlot = self.plotToEdit {
                if self.shouldShowConfirmationDialog {
                    let alert = UIAlertController(
                        title: "Are you sure?",
                        message: "Your changes to this plot will be lost.",
                        preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: { (alertAction) -> Void in
                        // If we are canceling our changes to the plot,
                        // We need to update what is on the backend to what
                        // was there prior to the edit.
                        println("Reverting edited plot...")
                        self.showActivityBarButton()
                        if let plot = self.plotToSave {
                            // Revert the plot to save back to 
                            // how it was when it was first loaded
                            plot.name = oldPlot.name
                            plot.tracks = oldPlot.tracks
                            plot.xDimension = oldPlot.xDimension
                            plot.yDimension = oldPlot.yDimension
                            
                            // Then sync that with the dashboard
                            self.syncPlotWithDashboardWithCallback({ (error, newestID) -> Void in
                                self.hideActivityBarButton()
                                if error == nil {
                                    self.dismissViewControllerAnimated(true, completion: nil)
                                } else {
                                    println("Error syncing plot: \(error!)")
                                }
                            })
                        }
                    }))
                        
                    alert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                // Otherwise, the user is canceling a Add Plot operation.
                // The plot may have been saved to the backend already, 
                // however. This means we need to revert the
                /*
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
                */
            }
        }
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
    
}

extension AddEditPlotTableViewController: UITableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !self.isDisabled {
            switch indexPath.section {
            case self.plotNameSection: self.plotNameTextField?.becomeFirstResponder()
            case self.plotPropertiesSection:
                switch indexPath.row {
                case self.xDimensionRow: self.xDimensionTextField?.becomeFirstResponder()
                case self.yDimensionRow: self.yDimensionTextField?.becomeFirstResponder()
                default: break
                }
            case self.plotTracksSection:
                if let plot = self.plotToSave {
                    if let tracks = plot.tracks {
                        let rowIndex = indexPath.row
                        if rowIndex == tracks.count {
                            // The add track button was tapped, 
                            // so we need to sync this plot with the backend 
                            // so track curves can be saved. 
                            self.showActivityBarButton()
                            self.savePlotWithCallback({ (error, newestID) -> Void in
                                self.hideActivityBarButton()
                                if error == nil {
                                    self.performSegueWithIdentifier(
                                        AddEditTrackNavigationController.entrySegueIdentifier(),
                                        sender: nil)
                                } else {
                                    println(error!)
                                }
                            })
                        } else if rowIndex < tracks.count {
                            self.performSegueWithIdentifier(
                                AddEditTrackNavigationController.entrySegueIdentifier(),
                                sender: rowIndex)
                        } else {
                            println("Error: Unknown row index for track.")
                        }
                    }
                }
            default: println("Error: Unknow section selected in table.")
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension AddEditPlotTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result = ""
        
        switch section {
        case self.plotNameSection: result = "Name"
        case self.plotPropertiesSection: result = "Properties"
        case self.plotTracksSection: result = "Tracks"
        default: result = ""
        }
        
        return result
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        switch section {
        case self.plotNameSection: numberOfRows = 1
        case self.plotPropertiesSection: numberOfRows = self.plotPropertiesNumberOfRows
        case self.plotTracksSection:
            if let plot = self.plotToSave {
                if let tracks = plot.tracks {
                    numberOfRows = tracks.count + 1
                }
            }
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    private func createPlotNameCell() -> TextFieldCell {
        let textFieldCell = tableView.dequeueReusableCellWithIdentifier(TextFieldCell.cellIdentifier()) as! TextFieldCell
        textFieldCell.textField.placeholder = "Plot Name"
        
        if let plot = self.plotToSave {
            textFieldCell.textField.text = plot.name
        }
        
        if let placeholder = textFieldCell.textField.placeholder {
            textFieldCell.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
        }
        self.plotNameTextField = textFieldCell.textField
        return textFieldCell
    }
    
    private func createXDimensionCell() -> TextFieldDetailCell {
        let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell!
        self.xDimensionTextField = textFieldDetailCell.textField
        textFieldDetailCell.textFieldLabel.text = "X Dimension"
        if let textField = textFieldDetailCell.textField {
            textField.placeholder = "0"
            
            if let plot = self.plotToSave {
                textField.text = "\(plot.xDimension)"
            }
            
            if let placeholder = textField.placeholder {
                textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
            }
        }
        
        return textFieldDetailCell
    }
    
    private func createYDimensionCell() -> TextFieldDetailCell {
        
        let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell!
        self.yDimensionTextField = textFieldDetailCell.textField
        textFieldDetailCell.textFieldLabel.text = "Y Dimension"
        if let textField = textFieldDetailCell.textField {
            textField.placeholder = "0"
            
            if let plot = self.plotToSave {
                textField.text = "\(plot.yDimension)"
            }
            
            if let placeholder = textField.placeholder {
                textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
            }
        }
        
        return textFieldDetailCell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.plotNameSection: cell = self.createPlotNameCell()
        case self.plotPropertiesSection:
            switch indexPath.row {
            case self.xDimensionRow: cell = self.createXDimensionCell()
            case self.yDimensionRow: cell = self.createYDimensionCell()
            default: break
            }
        case self.plotTracksSection:
            if let plot = self.plotToSave {
                if let tracks = plot.tracks {
                    if indexPath.row < tracks.count {
                        cell = tableView.dequeueReusableCellWithIdentifier(LabelDisclosureCell.cellIdentifier()) as! LabelDisclosureCell
                        
                        let track = tracks[indexPath.row]
                        
                        if let label = cell.textLabel {
                            if let id = track.id {
                                label.text = "Track \(id)"
                            }
                        }
                    } else {
                        cell = tableView.dequeueReusableCellWithIdentifier(LabelCell.cellIdentifier()) as! LabelCell
                        if let label = cell.textLabel {
                            label.text = "Add New Track..."
                        }
                        
                    }
                }
            }
            
        default: break
        }
        return cell
    }
}
