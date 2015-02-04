//
//  SegmentControlToolbar.swift
//  DrillAlert
//
//  Created by Lucas David on 2/2/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SegmentControlToolbar: UIToolbar {
    var segmentedControl: UISegmentedControl!
    var segmentedControlItems: [AnyObject]!
    
    init(frame: CGRect, items: [AnyObject]!, delegate: UIViewController, action: Selector) {
        let segmentedControlHeight: CGFloat = 24.0
        let segmentedControlWidth: CGFloat = frame.size.width / 2
        let segmentedControlXCoord: CGFloat = frame.size.width / 4
        let segmentedControlYCoord: CGFloat = (frame.size.height - segmentedControlHeight) / 2
        
        let segmentedControlRect = CGRectMake(
            segmentedControlXCoord,
            segmentedControlYCoord,
            segmentedControlWidth,
            segmentedControlHeight)
        
        self.segmentedControl = UISegmentedControl(items: items)
        self.segmentedControl.frame = segmentedControlRect
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(
            delegate,
            action: action,
            forControlEvents: .ValueChanged)
        
        self.segmentedControlItems = items
        super.init(frame: frame)
        /*
        self.backgroundColor =  UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
        self.translucent = false
        self.barTintColor =  UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
        */
        
        self.addSubview(segmentedControl)
        self.addBottomBorder()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}