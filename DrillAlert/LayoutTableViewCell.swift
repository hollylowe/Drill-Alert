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
    
    func setupWithLayout(layout: Layout) {
        if let label = self.textLabel {
            label.text = "\(layout.name)"
        }
    }
    
    class func cellIdentifier() -> String! {
        return "LayoutTableViewCell"
    }
    
}