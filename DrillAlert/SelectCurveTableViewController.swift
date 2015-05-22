//
//  SelectCurveTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/12/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SelectCurveTableViewController: LoadingTableViewController {
    var user: User!
    var wellbore: Wellbore!
    var delegate: AddEditTrackTableViewController!
    var currentCurves = Array<Curve>()
    var curves = Array<Curve>()
    
    func canceBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        self.dataSource = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: "canceBarButtonItemTapped:")
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LabelCell.cellIdentifier()) as! LabelCell
        let curve = self.curves[indexPath.row]
        if let label = cell.textLabel {
            label.text = curve.name
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var shouldAddCurve = true
        let curve = self.curves[indexPath.row]
        
        // Verify the curve hasn't been added yet
        for currentCurve in self.currentCurves {
            if curve.id == currentCurve.id {
                shouldAddCurve = false
                break
            }
        }
        
        if shouldAddCurve {
            self.delegate.addCurve(curve)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            let alertController = UIAlertController(
                title: "Duplicate Curve",
                message: "This curve has already been added to the track.",
                preferredStyle: .Alert)
            let okayAction = UIAlertAction(title: "Okay", style: .Cancel) { (action) in }
            
            alertController.addAction(okayAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.curves.count
    }
    
    class func entrySegueIdentifier() -> String! {
        return "SelectCurveTableViewController"
    }
}

extension SelectCurveTableViewController: LoadingTableViewControllerDataSource {
    func dataLoadOperation() {
        let (newCurves, error) = Curve.getCurvesForUser(self.user, andWellbore: self.wellbore)
        
        if error == nil {
            if let curves = newCurves {
                self.curves = curves
            }
        } else {
            // TODO: Show user error
            self.loadError = true
            println(error)
        }
    }
    
    func shouldShowNoDataMessage() -> Bool {
        return self.curves.count == 0
    }
    
    func noDataMessage() -> String {
        return "No Curves"
    }
}