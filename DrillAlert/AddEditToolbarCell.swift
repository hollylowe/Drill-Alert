//
//  AddEditToolbarCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditToolbarCell: UITableViewCell {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    class func cellIdentifier() -> String {
        return "AddEditToolbarCell"
    }
    
    func disable() {
        self.editButton.enabled = false
        self.addButton.enabled = false
    }
    
    func enable() {
        self.editButton.enabled = true
        self.addButton.enabled = true
    }
}