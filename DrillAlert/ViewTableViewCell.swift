//
//  ViewTableViewCell.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/15/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewTitleLabel: UILabel!
    
    func setupWithView(view: View) {
        self.viewTitleLabel.text = "\(view.name)"
    }
    
    class func cellIdentifier() -> String! {
        return "ViewTableViewCell"
    }
    
}