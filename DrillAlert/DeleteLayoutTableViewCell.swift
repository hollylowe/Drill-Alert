//
//  DeleteLayoutTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class DeleteLayoutTableViewCell: UITableViewCell {
    @IBOutlet weak var deleteLayoutButton: UIButton!
    class func cellIdentifier() -> String {
        return "DeleteLayoutTableViewCell"
    }
}