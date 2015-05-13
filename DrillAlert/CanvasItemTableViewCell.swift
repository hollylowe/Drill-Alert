//
//  CanvasItemTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CanvasItemTableViewCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "CanvasItemTableViewCell"
    }
    
    func setupWithCanvasItem(canvasItem: CanvasItem) {
        if let label = self.textLabel {
            label.text = canvasItem.name
        }
    }
}