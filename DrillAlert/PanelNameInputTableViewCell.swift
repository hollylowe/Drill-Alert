//
//  PanelNameInputTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class PanelNameInputTableViewCell: UITableViewCell {
    @IBOutlet weak var panelNameTextField: UITextField!
    
    class func cellIdentifier() -> String! {
        return "PanelNameInputTableViewCell"
    }
}
