//
//  PlotNameCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/13/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class PlotNameCell: UITableViewCell {
    @IBOutlet weak var plotNameLabel: UILabel!
    class func cellIdentifier() -> String {
        return "PlotNameCell"
    }
}