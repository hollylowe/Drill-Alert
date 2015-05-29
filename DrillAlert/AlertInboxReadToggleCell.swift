//
//  AlertInboxReadToggleCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/28/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertInboxReadToggleCell: UITableViewCell {
    @IBOutlet weak var readLabel: UILabel!
    class func cellIdentifier() -> String {
        return "AlertInboxReadToggleCell"
    }
}
