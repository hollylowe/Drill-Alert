//
//  CanvasNameInputTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit


class CanvasNameInputTableViewCell: UITableViewCell {
    @IBOutlet weak var canvasNameTextField: UITextField!
    class func cellIdentifier() -> String {
        return "CanvasNameInputTableViewCell"
    }
}