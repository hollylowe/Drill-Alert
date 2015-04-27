//
//  PlotUnitsCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class PlotUnitsCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "PlotUnitsCell"
    }
    
    func setupWithUnits(units: PlotUnits) {
        if let label = self.textLabel {
            label.text = units.getTitle()
        }
    }
}