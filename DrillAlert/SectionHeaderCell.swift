//
//  SectionHeaderCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/14/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SectionHeaderCell: UITableViewCell {
    @IBOutlet weak var sectionLabel: UILabel!
    class func cellIdentifier() -> String {
        return "SectionHeaderCell"
    }
}