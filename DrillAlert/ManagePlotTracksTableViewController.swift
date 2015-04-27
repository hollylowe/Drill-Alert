//
//  ManagePlotTracksTableViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ManagePlotTracksTableViewController: UITableViewController {
    var tracks = Array<PlotTrack>()
    //
    //  -----------------------
    // | Table View Properties |
    //  -----------------------
    //
    let tracksSection = 0
    let numberOfSections = 1
    
    //
    //  -----------------------
    // |    Class Functions    |
    //  -----------------------
    //
    class func storyboardIdentifier() -> String {
        return "ManagePlotTracksTableViewController"
    }
}

extension ManagePlotTracksTableViewController: UITableViewDelegate {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfSections
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tracks"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        
        if section == self.tracksSection {
            numberOfRows = self.tracks.count + 1
        }
        
        return numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.section == self.tracksSection {
            if indexPath.row == self.tracks.count {
                // It's the last one, so make it the add cell
                cell = tableView.dequeueReusableCellWithIdentifier(AddPlotTrackTableViewCell.cellIdentifier()) as! AddPlotTrackTableViewCell!
                
            } else {
                // It's a track
                let trackCell = tableView.dequeueReusableCellWithIdentifier(PlotTrackTableViewCell.cellIdentifier()) as! PlotTrackTableViewCell!
                let track = self.tracks[indexPath.row]
                trackCell.setupWithTrack(track)
                cell = trackCell
            }
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == self.tracksSection {
            if indexPath.row == self.tracks.count {
                // Show add track
            } else {
                // Show track edit
            }
        }
    }
    
}