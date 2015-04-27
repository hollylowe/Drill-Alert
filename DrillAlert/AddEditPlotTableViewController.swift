//
//  AddPlotTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/18/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditPlotTableViewController: UITableViewController {
    
    @IBOutlet weak var plotNameTextField: UITextField!
    @IBOutlet weak var stepSizeTextField: UITextField!
    @IBOutlet weak var startRangeTextField: UITextField!
    @IBOutlet weak var endRangeTextField: UITextField!
    
    // Implicit, set by the previous view controller
    var delegate: AddEditLayoutTableViewController!
    var wellboreDetailViewController: WellboreDetailViewController!
    var plotToEdit: Panel?
    
    //
    //  -------------------------
    // | Current Plot Properties |
    //  -------------------------
    //
    var selectedIVT: PlotIndependentVariableType? {
        didSet {
            if let label = self.IVTCell.detailTextLabel {
                if let IVT = self.selectedIVT {
                    label.text = IVT.getTitle()
                }
            }
        }
    }
    var selectedUnits: PlotUnits? {
        didSet {
            if let label = self.UnitsCell.detailTextLabel {
                if let units = self.selectedUnits {
                    label.text = units.getTitle()
                }
            }
        }
    }
    
    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    @IBOutlet weak var IVTCell: UITableViewCell!
    @IBOutlet weak var UnitsCell: UITableViewCell!
    let unitsRow                    = 1
    let plotNameSection             = 0
    let plotTracksSection           = 2
    let plotPropertiesSection       = 1
    let independentVariableTypeRow  = 0
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        if let name = self.plotNameTextField.text {
            if let stepSize = self.stepSizeTextField.text {
                if let startRange = self.startRangeTextField.text {
                    if let endRange = self.endRangeTextField.text {
                        if let units = self.selectedUnits {
                            if let IVT = self.selectedIVT {
                                // Create a new Plot visualization
                                let newPlot = Plot(
                                    xPosition: 0,
                                    yPosition: 0,
                                    curveID: 0,
                                    units: units,
                                    independentVariableType: IVT,
                                    stepSize: 0,
                                    startRange: 0,
                                    endRange: 0,
                                    tracks: Array<PlotTrack>())
                                
                                // Create a visualization array with the new Plot
                                var visualizations = Array<Visualization>()
                                visualizations.append(newPlot)
                                
                                // Create a new Panel
                                let newPanel = Panel(
                                    name: name,
                                    position: 0,
                                    xDimension: 0,
                                    yDimension: 0,
                                    visualizations: visualizations)
                                newPanel.type = PanelType.Plot
                                self.delegate.addPanel(newPanel)
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func addPlotEntrySegueIdentifier() -> String {
        return "AddPlotTableViewControllerSegue"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Prepareing for segue")
        if segue.identifier == SelectIVTTableViewController.entrySegueIdentifier() {
            let viewController = segue.destinationViewController as! SelectIVTTableViewController
            viewController.delegate = self
        } else if segue.identifier == SelectUnitsTableViewController.entrySegueIdentifier() {
            let viewController = segue.destinationViewController as! SelectUnitsTableViewController
            viewController.delegate = self
        }
        
        super.prepareForSegue(segue, sender: sender)
    }
    
    override func viewDidLoad() {
        if let plot = self.plotToEdit {
            self.title = "Edit Plot"
            self.plotNameTextField.text = plot.name
            
            // TODO: Set IVT
            if let label = self.IVTCell.detailTextLabel {
                
            }
            
        } else {
            self.title = "Add Plot"
        }
        
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "AddEditPlotTableViewController"
    }
    
    
}
