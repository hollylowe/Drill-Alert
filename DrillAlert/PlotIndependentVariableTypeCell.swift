//
//  PlotIndependentVariableTypeCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class PlotIndependentVariableTypeCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "PlotIndependentVariableTypeCell"
    }
    
    func setupWithType(type: PlotIndependentVariableType) {
        if let label = self.textLabel {
            label.text = type.getTitle()
        }
    }
    
}