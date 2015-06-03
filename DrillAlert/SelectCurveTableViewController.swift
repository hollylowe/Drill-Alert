//
//  SelectCurveTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/12/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SelectCurveTableViewController: LoadingTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var user: User!
    var wellbore: Wellbore!
    var curveToEdit: Curve?
    var itemID: Int?
    var addEditAlertDelegate: AddEditAlertTableViewController?
    var addEditTrackDelegate: AddEditTrackTableViewController?
    var addEditCanvasItemDelegate: AddEditCanvasItemTableViewController?
    
    var currentCurves = Array<Curve>()
    var curveIVT: CurveIVT?
    var curves = Array<Curve>()
    var filteredCurves = Array<Curve>()
    var activityBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        self.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.blackColor()
        let activityView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 25, 25))
        activityView.startAnimating()
        activityView.hidden = false
        activityView.color = UIColor.grayColor()
        activityView.sizeToFit()
        activityView.autoresizingMask = (UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleBottomMargin)
        
        self.activityBarButtonItem = UIBarButtonItem(customView: activityView)
        
        super.viewDidLoad()
    }
    
    private func showActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(self.activityBarButtonItem, animated: true)
    }
    
    private func hideActivityBarButton() {
        self.navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: LabelCell!
        var curve: Curve!

        if let labelCell = tableView.dequeueReusableCellWithIdentifier(LabelCell.cellIdentifier()) as? LabelCell {
            cell = labelCell
        } else if tableView != self.tableView {
            tableView.backgroundColor = UIColor.blackColor()
            tableView.separatorColor = UIColor.blackColor()
            if let labelCell = self.tableView.dequeueReusableCellWithIdentifier(LabelCell.cellIdentifier()) as? LabelCell {
                cell = labelCell
            }
        }
        
        
        if self.searchBar.text.isEmpty {
            curve = self.curves[indexPath.row]
        } else {
            curve = self.filteredCurves[indexPath.row]
        }

        
        if let label = cell.textLabel {
            label.text = curve.name
        }
        
        return cell
    }
    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String) {
            self.filterContentForSearchText(searchText)
    }
    func filterContentForSearchText(searchText: String) {
        self.filteredCurves = self.curves.filter({( curve: Curve) -> Bool in
            let stringMatch = curve.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
    }
    func shouldReloadTableForSearchString(searchString: String) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func saveNewItemCurve(itemCurve: ItemCurve, withCallback callback: ((error: String?) -> Void)) {
        itemCurve.postToBackendForUser(self.user, withCallback: { (error) -> Void in
            if error == nil {
                callback(error: nil)
            } else {
                callback(error: error!)
            }
        })
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var curve: Curve!
        
        if self.searchBar.text.isEmpty {
            curve = self.curves[indexPath.row]
        } else {
            curve = self.filteredCurves[indexPath.row]
        }

        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let delegate = self.addEditAlertDelegate {
            delegate.setSelectedCurve(curve)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        if let delegate = self.addEditTrackDelegate {
            if let oldCurve = self.curveToEdit {
                // delegate.swapOldCurve(oldCurve, withNewCurve: curve)
            } else {
                var itemCurve = ItemCurve(curveID: curve.id)
                itemCurve.curve = curve
                if let itemID = self.itemID {
                    itemCurve.itemID = itemID
                    self.showActivityBarButton()
                    self.saveNewItemCurve(itemCurve, withCallback: { (error) -> Void in
                        self.hideActivityBarButton()
                        if error == nil {
                            delegate.addItemCurve(itemCurve)
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        } else {
                            println("Error saving item curve. \(error!)")
                        }
                    })
                } else {
                    println("Error: Could not add item curve: there was no Item ID given.")
                }
                
            }
            
        }

        
        /*
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
            // self.delegate.addCurve(curve)
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
        */
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if self.searchBar.text.isEmpty {
            numberOfRows = self.curves.count
        } else {
            numberOfRows = self.filteredCurves.count
        }
        return numberOfRows
    }
    
    class func entrySegueIdentifier() -> String! {
        return "SelectCurveTableViewController"
    }
}

extension SelectCurveTableViewController: LoadingTableViewControllerDataSource {
    func dataLoadOperation() {
        let (newCurves, error) = Curve.getCurvesForUser(self.user, andWellbore: self.wellbore, andIVT: self.curveIVT)
        
        if error == nil {
            if let curves = newCurves {
                self.curves = curves
                self.curves.sort({ (firstCurve, secondCurve) -> Bool in
                    return firstCurve.name.localizedCaseInsensitiveCompare(secondCurve.name) == NSComparisonResult.OrderedAscending
                })
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