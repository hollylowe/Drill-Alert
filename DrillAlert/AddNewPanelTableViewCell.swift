//
//  AddNewPanelTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddNewPanelTableViewCell: UITableViewCell {
    @IBOutlet weak var addNewPanelButton: UIButton!
    class func cellIdentifier() -> String! {
        return "AddNewPanelTableViewCell"
    }
}