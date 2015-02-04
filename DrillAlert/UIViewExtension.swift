//
//  UIViewExtension.swift
//  DrillAlert
//
//  Created by Lucas David on 11/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit

extension UIView {
    func addBottomBorder() {
        let border = CALayer()
        border.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0).CGColor
        border.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)
        self.layer.addSublayer(border)
    }
}