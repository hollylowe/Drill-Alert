//
//  CanvasItemTypeTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CanvasItemTypeTableViewCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "CanvasItemTypeTableViewCell"
    }
    
    func setupWithCanvasItemType(type: CanvasItemType) {
        if let label = self.textLabel {
            label.text = type.getTitle()
        }
    }
}