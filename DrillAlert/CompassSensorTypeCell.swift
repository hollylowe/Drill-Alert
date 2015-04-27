//
//  CompassSensorTypeCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CompassSensorTypeCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "CompassSensorTypeCell"
    }
    
    func setupWithSensorType(sensorType: CompassSensorType) {
        if let label = self.textLabel {
            label.text = sensorType.getTitle()
        }
    }
}