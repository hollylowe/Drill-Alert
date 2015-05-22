import Foundation
import UIKit

class AddEditPlotTableViewController: UITableViewController {
    
    // Implicit, set by the previous view controller
    var delegate: AddEditDashboardTableViewController!
    var wellbore: Wellbore!
    var user: User!
    
    // Set if we're editing a plot
    var plotToEdit: Page?
    
    // Set if we're adding a plot from existing
    var existingPlot: Page?
    
    //
    //  -------------------------
    // | Current Plot Properties |
    //  -------------------------
    //
    var selectedIVT: PlotIndependentVariableType? {
        didSet {
            if let cell = self.IVTCell {
                if let label = cell.detailTextLabel {
                    if let IVT = self.selectedIVT {
                        label.text = IVT.getTitle()
                    }
                }
            }
        }
    }
    var selectedUnits: PlotUnits? {
        didSet {
            if let cell = self.unitsCell {
                if let label = cell.detailTextLabel {
                    if let units = self.selectedUnits {
                        label.text = units.getTitle()
                    }
                }
            }
        }
    }
    
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
    let plotPropertiesNumberOfRows  = 5
    let unitsRow                    = 1
    let independentVariableTypeRow  = 0
    let stepSizeRow                 = 2
    let endRangeRow                 = 4
    let startRangeRow               = 3
    
    // Dynamic TextFields
    var plotNameTextField: UITextField?
    var startRangeTextField: UITextField?
    var stepSizeTextField: UITextField?
    var endRangeTextField: UITextField?

    // Dynamic Cells
    var IVTCell: LabelDetailDisclosureCell?
    var unitsCell: LabelDetailDisclosureCell?
    
    var tracks = Array<Track>()
    class func addPlotFromExistingSegue() -> String {
        return "AddPlotFromExistingSegue"
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        if let plotNameTextField = self.plotNameTextField {
            if let stepSizeTextField = self.stepSizeTextField {
                if let startRangeTextField = self.startRangeTextField {
                    if let endRangeTextField = self.endRangeTextField {
                        if let name = plotNameTextField.text {
                            if let stepSize = stepSizeTextField.text {
                                if let startRange = startRangeTextField.text {
                                    if let endRange = endRangeTextField.text {
                                        if let units = self.selectedUnits {
                                            if let IVT = self.selectedIVT {
                                                // Create a new Plot Page
                                                let newPlot = Plot(
                                                    name: name,
                                                    position: 0,
                                                    xDimension: 0,
                                                    yDimension: 0,
                                                    curveID: 0,
                                                    units: units,
                                                    independentVariableType: IVT,
                                                    stepSize: stepSize,
                                                    startRange: startRange,
                                                    endRange: endRange,
                                                    tracks: self.tracks)
                                                
                                                self.delegate.addPage(newPlot)
                                                self.dismissViewControllerAnimated(true, completion: nil)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addTrack(track: Track) {
        self.tracks.append(track)
        self.tableView.reloadData()
    }
    
    class func addPlotEntrySegueIdentifier() -> String {
        return "AddPlotTableViewControllerSegue"
    }
    
    class func storyboardIdentifier() -> String! {
        return "AddEditPlotTableViewController"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SelectIVTTableViewController.entrySegueIdentifier() {
            let viewController = segue.destinationViewController as! SelectIVTTableViewController
            viewController.delegate = self
        } else if segue.identifier == SelectUnitsTableViewController.entrySegueIdentifier() {
            let viewController = segue.destinationViewController as! SelectUnitsTableViewController
            viewController.delegate = self
        } else if segue.identifier == AddEditTrackNavigationController.entrySegueIdentifier() {
            let destination = segue.destinationViewController as! AddEditTrackNavigationController
            let viewController = destination.viewControllers[0] as! AddEditTrackTableViewController
            
            viewController.delegate = self
            viewController.wellbore = self.wellbore
            viewController.user = self.user
            if let track = sender as? Track {
                viewController.trackToEdit = track
                
            }
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        if let plot = self.plotToEdit {
            self.title = "Edit Plot"
            
            // TODO: Set IVT
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: "cancelBarButtonItemTapped:")
        } else {
            self.title = "Add Plot"
        }
        
        super.viewDidLoad()
    }
    
    
}

extension AddEditPlotTableViewController: UITableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == self.plotNameSection {
            if let textField = self.plotNameTextField {
                textField.becomeFirstResponder()
            }
        }
        
        if indexPath.section == self.plotPropertiesSection {
            switch indexPath.row {
            case self.stepSizeRow:
                if let textField = self.stepSizeTextField {
                    textField.becomeFirstResponder()
                }
            case self.startRangeRow:
                if let textField = self.startRangeTextField {
                    textField.becomeFirstResponder()
                }
            case self.endRangeRow:
                if let textField = self.endRangeTextField {
                    textField.becomeFirstResponder()
                }
            case self.independentVariableTypeRow:
                self.performSegueWithIdentifier(SelectIVTTableViewController.entrySegueIdentifier(), sender: nil)
            case self.unitsRow:
                self.performSegueWithIdentifier(SelectUnitsTableViewController.entrySegueIdentifier(), sender: nil)
            default: break
            }
            
        }
        
        if indexPath.section == self.plotTracksSection {
            if indexPath.row == self.tracks.count {
                self.performSegueWithIdentifier(AddEditTrackNavigationController.entrySegueIdentifier(), sender: nil)
            } else if indexPath.row < self.tracks.count {
                let track = self.tracks[indexPath.row]
                self.performSegueWithIdentifier(AddEditTrackNavigationController.entrySegueIdentifier(), sender: track)

            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension AddEditPlotTableViewController: UITableViewDataSource {
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result = ""
        
        switch section {
        case self.plotNameSection: result = ""
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
        case self.plotTracksSection: numberOfRows = self.tracks.count + 1
        default: numberOfRows = 0
        }
        
        return numberOfRows
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case self.plotNameSection:
            let textFieldCell = tableView.dequeueReusableCellWithIdentifier(TextFieldCell.cellIdentifier()) as! TextFieldCell
            self.plotNameTextField = textFieldCell.textField
            textFieldCell.textField.placeholder = "Plot Name"

            if let plot = self.plotToEdit {
                textFieldCell.textField.text = plot.name
            } else if let plot = self.existingPlot {
                textFieldCell.textField.text = plot.name
            }
            
            cell = textFieldCell
        case self.plotPropertiesSection:
            switch indexPath.row {
            case self.independentVariableTypeRow:
                if let labelDetailDisclosureCell = tableView.dequeueReusableCellWithIdentifier(LabelDetailDisclosureCell.cellIdentifier()) as? LabelDetailDisclosureCell {
                    self.IVTCell = labelDetailDisclosureCell
                    
                    // TODO: Set the IVT from the edit / existing plots
                    
                    cell = labelDetailDisclosureCell
                    if let label = cell.textLabel {
                        label.text = "IVT"
                    }
                    
                    if let detailLabel = cell.detailTextLabel {
                        detailLabel.text = "None"
                    }
                }
            case self.unitsRow:
                if let labelDetailDisclosureCell = tableView.dequeueReusableCellWithIdentifier(LabelDetailDisclosureCell.cellIdentifier()) as? LabelDetailDisclosureCell {
                    self.unitsCell = labelDetailDisclosureCell
                    cell = labelDetailDisclosureCell
                    
                    // TODO: Set the Units from the edit / existing plots

                    
                    if let label = cell.textLabel {
                        label.text = "Units"
                    }
                    
                    if let detailLabel = cell.detailTextLabel {
                        detailLabel.text = "None"
                    }
                }
                
            case self.stepSizeRow:
                let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell!
                self.stepSizeTextField = textFieldDetailCell.textField
                textFieldDetailCell.textFieldLabel.text = "Step Size"
                if let textField = textFieldDetailCell.textField {
                    textField.placeholder = "0.0"
                }
                // TODO: Set from the edit / existing plots

                cell = textFieldDetailCell
            case self.startRangeRow:
                 let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell!
                 self.startRangeTextField = textFieldDetailCell.textField
                 textFieldDetailCell.textFieldLabel.text = "Start Range"
                 if let textField = textFieldDetailCell.textField {
                    textField.placeholder = "0.0"
                 }
                 // TODO: Set from the edit / existing plots

                 cell = textFieldDetailCell
            case self.endRangeRow:
                 let textFieldDetailCell = tableView.dequeueReusableCellWithIdentifier(TextFieldDetailCell.cellIdentifier()) as! TextFieldDetailCell!
                 self.endRangeTextField = textFieldDetailCell.textField
                 textFieldDetailCell.textFieldLabel.text = "End Range"

                 if let textField = textFieldDetailCell.textField {
                    textField.placeholder = "0.0"
                 }
                 // TODO: Set from the edit / existing plots

                 cell = textFieldDetailCell
            default: break
            }
        case self.plotTracksSection:
            if indexPath.row < self.tracks.count {
                cell = tableView.dequeueReusableCellWithIdentifier(LabelDisclosureCell.cellIdentifier()) as! LabelDisclosureCell
                
                let track = self.tracks[indexPath.row]
                
                if let label = cell.textLabel {
                    label.text = track.name
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(LabelCell.cellIdentifier()) as! LabelCell
                if let label = cell.textLabel {
                    label.text = "Add New Track..."
                }
                
            }
        default: break
        }
        return cell
    }
}
