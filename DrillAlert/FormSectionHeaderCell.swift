//
//  FormSectionHeaderCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class FormSectionHeaderCell: UITableViewCell {
    @IBOutlet weak var sectionLabelBackground: UIView!
    @IBOutlet weak var sectionLabel: UILabel!
    class func cellIdentifier() -> String {
        return "FormSectionHeaderCell"
    }
}