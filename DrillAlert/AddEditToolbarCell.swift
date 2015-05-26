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
    
    @IBOutlet weak var sectionLabelBackground: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var sectionLabel: UILabel!
    
    class func cellIdentifier() -> String {
        return "AddEditToolbarCell"
    }
}