//
//  EditLayoutTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 4/24/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class EditLayoutTableViewCell: UITableViewCell {
    class func cellIdentifier() -> String {
        return "EditLayoutTableViewCell"
    }
    
    func setupWithLayout(layout: Layout) {
        if let label = self.textLabel {
            label.text = layout.name
        }
    }
}