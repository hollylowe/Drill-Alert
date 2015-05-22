//
//  CompassNameCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/13/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CompassNameCell: UITableViewCell {
    
    @IBOutlet weak var compassNameLabel: UILabel!
    class func cellIdentifier() -> String {
        return "CompassNameCell"
    }
}