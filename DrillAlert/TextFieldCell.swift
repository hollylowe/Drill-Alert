//
//  TextFieldCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/11/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class TextFieldCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    class func cellIdentifier() -> String {
        return "TextFieldCell"
    }
}