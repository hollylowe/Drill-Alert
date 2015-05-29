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
    
    func setupWithLabelText(labelText: String, placeholder: String, andTextFieldText opTextFieldText: String?) {
        self.textFieldLabel.text = labelText
        self.textField.placeholder = placeholder
        
        if let textFieldText = opTextFieldText {
            self.textField.text = textFieldText
        }
        
        if let placeholder = self.textField.placeholder {
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor(white: 0.52, alpha: 1.0)])
        }

    }
}