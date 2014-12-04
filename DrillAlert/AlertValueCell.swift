//
//  AlertValueCell.swift
//  DrillAlert
//
//  Created by Lucas David on 12/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertValueCell: UITableViewCell {
    @IBOutlet weak var valueTextField: UITextField!
    
    class func getCellIdentifier() -> String! {
        return "AlertValueCell"
    }
}
