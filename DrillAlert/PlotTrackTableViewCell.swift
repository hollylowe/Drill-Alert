//
//  PlotTrackTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class PlotTrackTableViewCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "PlotTrackTableViewCell"
    }
    
    func setupWithTrack(track: PlotTrack) {
        if let label = self.textLabel {
            label.text = track.getTitle()
        }
    }
    
}