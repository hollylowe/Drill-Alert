//
//  CompassNameInputTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CompassNameInputTableViewCell: UITableViewCell {
    @IBOutlet weak var compassNameTextField: UITextField!
    
    class func cellIdentifier() -> String {
        return "CompassNameInputTableViewCell"
    }
}