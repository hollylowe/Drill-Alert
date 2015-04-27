//
//  ViewTableViewCell.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/15/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class LayoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var layoutTitleLabel: UILabel!
    
    func setupWithLayout(layout: Layout) {
        self.layoutTitleLabel.text = "\(layout.name)"
    }
    
    class func cellIdentifier() -> String! {
        return "LayoutTableViewCell"
    }
    
}