//
//  CanvasNameCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/13/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CanvasNameCell: UITableViewCell {
    
    @IBOutlet weak var canvasNameLabel: UILabel!
    
    class func cellIdentifier() -> String {
        return "CanvasNameCell"
    }
}