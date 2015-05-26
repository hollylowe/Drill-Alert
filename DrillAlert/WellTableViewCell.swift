//
//  WellTableViewCell.swift
//  DrillAlert
//
//  Created by Lucas David on 3/9/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class WellTableViewCell: UITableViewCell {
    @IBOutlet weak var wellNameLabel: UILabel!
    @IBOutlet weak var wellLocationLabel: UILabel!
    let height: CGFloat = 62.0
    
    func setupWithWell(well: Well) {
        // ?self.backgroundColor = UIColor.whiteColor()
        /*
        var sepFrame = CGRectMake(0, self.height - 0.5, self.frame.size.width, 0.5)
        var seperatorView = UIView(frame: sepFrame)
        seperatorView.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
        
        self.addSubview(seperatorView)
        */
        self.wellNameLabel.text = well.name
        self.wellLocationLabel.text = well.location
    }
}