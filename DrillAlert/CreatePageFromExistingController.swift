//
//  CreatePageFromExistingController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/13/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CreatePageFromExistingController: LoadingTableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    var user: User!
    var delegate: AddEditDashboardTableViewController!
    
    var filteredCanvasPages = Array<Page>()
    var filteredPlotPages = Array<Page>()
    var filteredCompassPages = Array<Page>()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var canvasPages = Array<Page>()
    var plotPages = Array<Page>()
    var compassPages = Array<Page>()
    
    let numberOfSections = 3
    let plotSection = 0
    let canvasSection = 1
    let compassSection = 2
    
    override func viewDidLoad() {
        self.dataSource = self
        
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedPage: Page?

        if self.searchBar.text.isEmpty {
            switch indexPath.section {
            case plotSection: selectedPage = self.plotPages[indexPath.row]
            case canvasSection: selectedPage = self.canvasPages[indexPath.row]
            case compassSection: selectedPage = self.compassPages[indexPath.row]
            default: break
            }
        } else {
            switch indexPath.section {
            case plotSection: selectedPage = self.filteredPlotPages[indexPath.row]
            case canvasSection: selectedPage = self.filteredCanvasPages[indexPath.row]
            case compassSection: selectedPage = self.filteredCompassPages[indexPath.row]
            default: break
            }
        }
        
        if let page = selectedPage {
            switch page.type {
            case .Plot: self.presentAddPlotFromExistingWithPage(page)
            case .Canvas: self.presentAddCanvasFromExistingWithPage(page)
            case .Compass: self.presentAddCompassFromExistingWithPage(page)
            default: break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == AddEditCanvasTableViewController.addCanvasFromExistingSegue() {
            let viewController = segue.destinationViewController as! AddEditCanvasTableViewController
            if let canvas = sender as? Page {
                viewController.existingCanvas = canvas
                viewController.delegate = self.delegate
            }
        } else if segue.identifier == AddEditPlotTableViewController.addPlotFromExistingSegue() {
            let viewController = segue.destinationViewController as! AddEditPlotTableViewController
            if let plot = sender as? Page {
                viewController.existingPlot = plot
                viewController.delegate = self.delegate
            }
        } else if segue.identifier == AddEditCompassTableViewController.addCompassFromExistingSegue() {
            let viewController = segue.destinationViewController as! AddEditCompassTableViewController
            if let compass = sender as? Page {
                viewController.existingCompass = compass
                // viewController.delegate = self.delegate
            }
        }
    }
    
    func presentAddCanvasFromExistingWithPage(page: Page) {
        self.performSegueWithIdentifier(AddEditCanvasTableViewController.addCanvasFromExistingSegue(), sender: page)
    }
    
    func presentAddPlotFromExistingWithPage(page: Page) {
        self.performSegueWithIdentifier(AddEditPlotTableViewController.addPlotFromExistingSegue(), sender: page)
    }
    
    func presentAddCompassFromExistingWithPage(page: Page) {
        self.performSegueWithIdentifier(AddEditCompassTableViewController.addCompassFromExistingSegue(), sender: page)
    }
    
    func searchBar(searchBar: UISearchBar,
        textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
    }
    
    class func entrySegueIdentifier() -> String {
        return "CreatePageFromExistingControllerSegue"
    }
    
    func filterContentForSearchText(searchText: String) {
        self.filteredPlotPages = self.plotPages.filter({( plot: Page) -> Bool in
            let stringMatch = plot.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
        self.filteredCanvasPages = self.canvasPages.filter({( canvas: Page) -> Bool in
            let stringMatch = canvas.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
        self.filteredCompassPages = self.compassPages.filter({( compass: Page) -> Bool in
            let stringMatch = compass.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
    }
    
    func shouldReloadTableForSearchString(searchString: String) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func compassNameCellForPage(page: Page) -> UITableViewCell! {
        var cell: UITableViewCell!

        if let compassNameCell = tableView.dequeueReusableCellWithIdentifier(CompassNameCell.cellIdentifier()) as? CompassNameCell {
            compassNameCell.compassNameLabel.text = page.name
            cell = compassNameCell
        } else if tableView != self.tableView {
            if let compassNameCell = self.tableView.dequeueReusableCellWithIdentifier(CompassNameCell.cellIdentifier()) as? CompassNameCell {
                compassNameCell.compassNameLabel.text = page.name
                cell = compassNameCell
            }
        }
        
        return cell
    }
    
    func plotNameCellForPage(page: Page) -> UITableViewCell! {
        var cell: UITableViewCell!
        
        if let plotNameCell = tableView.dequeueReusableCellWithIdentifier(PlotNameCell.cellIdentifier()) as? PlotNameCell {
            plotNameCell.plotNameLabel.text = page.name
            cell = plotNameCell
        } else if tableView != self.tableView {
            if let plotNameCell = self.tableView.dequeueReusableCellWithIdentifier(PlotNameCell.cellIdentifier()) as? PlotNameCell {
                plotNameCell.plotNameLabel.text = page.name
                cell = plotNameCell
            }
        }
        
        
        return cell
    }
    
    func canvasNameCellForPage(page: Page) -> UITableViewCell! {
        var cell: UITableViewCell!
        
        if let canvasCell = tableView.dequeueReusableCellWithIdentifier(CanvasNameCell.cellIdentifier()) as? CanvasNameCell {
            canvasCell.canvasNameLabel.text = page.name
            cell = canvasCell
        }  else if tableView != self.tableView {
            if  let canvasCell = self.tableView.dequeueReusableCellWithIdentifier(CanvasNameCell.cellIdentifier()) as? CanvasNameCell {
                canvasCell.canvasNameLabel.text = page.name
                cell = canvasCell
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if self.searchBar.text.isEmpty {
            switch indexPath.section {
            case self.plotSection:
                let page = self.plotPages[indexPath.row]
                cell = self.plotNameCellForPage(page)
            case self.canvasSection:
                let page = self.canvasPages[indexPath.row]
                cell = self.canvasNameCellForPage(page)
            case self.compassSection:
                let page = self.compassPages[indexPath.row]
                cell = self.compassNameCellForPage(page)
            default: break
            }
        } else {
            switch indexPath.section {
            case self.plotSection:
                let page = self.filteredPlotPages[indexPath.row]
                cell = self.plotNameCellForPage(page)
            case self.canvasSection:
                let page = self.filteredCanvasPages[indexPath.row]
                cell = self.canvasNameCellForPage(page)
            case self.compassSection:
                let page = self.filteredCompassPages[indexPath.row]
                cell = self.compassNameCellForPage(page)
            default: break
            }
        }
        

        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var result: String?
        
        if self.searchBar.text.isEmpty {
            switch section {
            case self.plotSection:
                if self.plotPages.count > 0 {
                    result = "Plot"
                }
            case self.canvasSection:
                if self.canvasPages.count > 0 {
                    result = "Canvas"
                }
            case self.compassSection:
                if self.compassPages.count > 0 {
                    result = "Compass"
                }
            default: break
            }
        } else {
            switch section {
            case self.plotSection:
                if self.filteredPlotPages.count > 0 {
                    result = "Plot"
                }
            case self.canvasSection:
                if self.filteredCanvasPages.count > 0 {
                    result = "Canvas"
                }
            case self.compassSection:
                if self.filteredCompassPages.count > 0 {
                    result = "Compass"
                }
            default: break
            }
        }
        
        return result
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if self.searchBar.text.isEmpty {
            switch section {
            case self.plotSection: numberOfRows = self.plotPages.count
            case self.canvasSection: numberOfRows = self.canvasPages.count
            case self.compassSection: numberOfRows = self.compassPages.count
            default: numberOfRows = 0
            }
        } else {
            switch section {
            case self.plotSection: numberOfRows = self.filteredPlotPages.count
            case self.canvasSection: numberOfRows = self.filteredCanvasPages.count
            case self.compassSection: numberOfRows = self.filteredCompassPages.count
            default: numberOfRows = 0
            }
        }
        
        return numberOfRows
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
}

extension CreatePageFromExistingController: LoadingTableViewControllerDataSource {
    func dataLoadOperation() {
        let (newDashboards, error) = Dashboard.getAllDashboardsForUser(self.user)
        
        if error == nil {
            for dashboard in newDashboards {
                for page in dashboard.pages {
                    switch page.type {
                    case .Plot: self.plotPages.append(page)
                    case .Canvas: self.canvasPages.append(page)
                    case .Compass: self.compassPages.append(page)
                    default: break
                    }
                }
            }
            
            self.plotPages.sort({ (firstPage, secondPage) -> Bool in
                return firstPage.name.localizedCaseInsensitiveCompare(secondPage.name) == NSComparisonResult.OrderedAscending
            })
            self.canvasPages.sort({ (firstPage, secondPage) -> Bool in
                return firstPage.name.localizedCaseInsensitiveCompare(secondPage.name) == NSComparisonResult.OrderedAscending
            })
            self.compassPages.sort({ (firstPage, secondPage) -> Bool in
                return firstPage.name.localizedCaseInsensitiveCompare(secondPage.name) == NSComparisonResult.OrderedAscending
            })
        } else {
            // TODO: Show user error
            self.loadError = true
            println(error)
        }
    }
    
    func shouldShowNoDataMessage() -> Bool {
        return self.plotPages.count == 0 && self.canvasPages.count == 0 && self.compassPages.count == 0
    }
    
    func noDataMessage() -> String {
        return "No Pages"
    }
}