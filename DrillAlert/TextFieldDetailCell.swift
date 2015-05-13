//
//  TextFieldDetailCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/11/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDetailCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    class func cellIdentifier() -> String {
        return "TextFieldDetailCell"
    }
}