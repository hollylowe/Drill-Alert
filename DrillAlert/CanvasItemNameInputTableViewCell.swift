//
//  CanvasItemNameInputTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CanvasItemNameInputTableViewCell: UITableViewCell {
    @IBOutlet weak var canvasItemNameTextField: UITextField!
    class func cellIdentifier() -> String {
        return "CanvasItemNameInputTableViewCell"
    }
}
