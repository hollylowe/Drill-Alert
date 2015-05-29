//
//  SegmentControlBadgeToolbar.swift
//  DrillAlert
//
//  Created by Lucas David on 5/28/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class BadgeView: UIView {
    var badgeNumber = 0
    var badgeLabel: UILabel!
    
    init(x: CGFloat, y: CGFloat, color: UIColor) {
        let width: CGFloat = 20.0
        let borderRadius: CGFloat = 1.0
        let height: CGFloat = 20.0
        // Put this at the given x coordinate,
        // shifted back by half the width to center it
        
        let mainFrame = CGRectMake(x - (width / 2), y, width, height)
        
        // Move this to the border radius
        let badgeLabelWidth = width - (borderRadius * 2)
        let badgeLabelFrame = CGRectMake(borderRadius, borderRadius, badgeLabelWidth, height - (borderRadius * 2))
        
        self.badgeLabel = UILabel(frame: badgeLabelFrame)
        self.badgeLabel.backgroundColor = UIColor(red: 0.153, green: 0.153, blue: 0.153, alpha: 1.0)
        self.badgeLabel.text = "0"
        self.badgeLabel.font = UIFont(name: "HelveticaNeue", size: 10.0)
        self.badgeLabel.textColor = UIColor.lightGrayColor()
        self.badgeLabel.textAlignment = .Center
        self.badgeLabel.layer.cornerRadius = badgeLabelWidth / 2
        self.badgeLabel.layer.masksToBounds = true
        self.badgeLabel.clipsToBounds = true
        super.init(frame: mainFrame)
        self.backgroundColor = color
        self.layer.cornerRadius = height / 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.addSubview(self.badgeLabel)
    }
    
    func updateBadgeNumber(number: Int) {
        self.badgeNumber = number
        self.badgeLabel.text = "\(self.badgeNumber)"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SegmentControlBadgeToolbar: UIToolbar {
    var segmentedControl: UISegmentedControl!
    var segmentedControlItems: [String]
    var segmentedControlWidth: CGFloat!
    var segmentedControlHeight: CGFloat!
    var segmentedControlXCoord: CGFloat!
    var segmentedControlYCoord: CGFloat!
    var badgeViews: [BadgeView]
    var colors: [UIColor]
    
    func updateColor() {
        self.segmentedControl.tintColor = colors[self.segmentedControl.selectedSegmentIndex]
        
        var index = 0
        for badgeView in self.badgeViews {
            let color = self.colors[self.segmentedControl.selectedSegmentIndex]
            if index == self.segmentedControl.selectedSegmentIndex {
                
                badgeView.backgroundColor = color
                badgeView.badgeLabel.backgroundColor = color
                badgeView.badgeLabel.textColor = self.barTintColor
            } else {
                // Not selected
                badgeView.backgroundColor = color
                badgeView.badgeLabel.textColor = color
                badgeView.badgeLabel.backgroundColor =  UIColor(red: 0.153, green: 0.153, blue: 0.153, alpha: 1.0)
            }
            index++
        }
        
    }
    
    private func setupSegmentedControl(items: [String], action: Selector) {
        self.segmentedControlHeight = 22.0
        self.segmentedControlWidth = frame.size.width - (frame.size.width / 8)
        self.segmentedControlXCoord = frame.size.width / 16
        self.segmentedControlYCoord = 5.0
        let segmentedControlRect = CGRectMake(
            segmentedControlXCoord,
            segmentedControlYCoord,
            segmentedControlWidth,
            segmentedControlHeight)
        self.segmentedControl = UISegmentedControl(items: items)
        self.segmentedControl.frame = segmentedControlRect
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.tintColor = UIColor.whiteColor()
    }
    
    private func setupBadgeViews(items: [String], itemColors: [UIColor]) {
        var index = 0
        let segmentWidth: CGFloat = self.segmentedControlWidth / CGFloat(items.count)
        let segmentCenter: CGFloat = segmentWidth / 2
        let badgeYCoord: CGFloat = 5.0
        for item in items {
            let newBadgeView = BadgeView(
                x: self.segmentedControlXCoord + segmentCenter + (segmentWidth * CGFloat(index)),
                y: self.segmentedControlYCoord + self.segmentedControlHeight + badgeYCoord,
                color: itemColors[index])
            self.badgeViews.append(newBadgeView)
            index++
        }
    }
    
    init(frame: CGRect, items: [String], itemColors: [UIColor], delegate: UIViewController, action: Selector) {
        self.segmentedControlItems = items
        self.badgeViews = [BadgeView]()
        self.colors = itemColors
        super.init(frame: frame)
        /*
        self.backgroundColor =  UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
        self.translucent = false
        self.barTintColor =  UIColor(red: 0.122, green: 0.122, blue: 0.122, alpha: 1.0)
        */
        self.setupSegmentedControl(items, action: action)
        
        self.segmentedControl.addTarget(
        delegate,
        action: action,
        forControlEvents: .ValueChanged)
        self.setupBadgeViews(items, itemColors: itemColors)
        self.barTintColor = UIColor(red: 0.096, green: 0.096, blue: 0.096, alpha: 1.0)
        self.segmentedControl.tintColor = itemColors[0]
        self.addSubview(self.segmentedControl)
        
        for badgeView in self.badgeViews {
            self.addSubview(badgeView)
        }
        self.updateColor()
        //self.addBottomBorder()
    }
    
    func updateBadgeAtIndex(index: Int, toNumber number: Int) {
        let badgeView = self.badgeViews[index]
        badgeView.updateBadgeNumber(number)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}