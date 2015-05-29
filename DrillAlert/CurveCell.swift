//
//  CurveCell.swift
//  DrillAlert
//
//  Created by Lucas David on 5/28/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class CurveCell: UITableViewCell {
    @IBOutlet weak var curveNameLabel: UILabel!
    @IBOutlet weak var curveIVTLabel: UILabel!
    class func cellIdentifier() -> String {
        return "CurveCell"
    }
    
    func setupWithCurve(curve: Curve) {
        self.curveNameLabel.text = curve.name
        self.curveIVTLabel.text = curve.IVT.toString()
    }
}