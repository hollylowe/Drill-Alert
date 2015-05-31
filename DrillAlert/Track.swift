//
//  Track.swift
//  DrillAlert
//
//  Created by Lucas David on 5/11/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
class Track: Item {
    init() {
        super.init(xPosition: 0, yPosition: 0, jsFileName: "Track.js")
    }
    
    init(xPosition: Int, yPosition: Int, itemSettings: ItemSettings) {
        super.init(
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: "Track.js",
            itemSettingsCollection: ItemSettingsCollection(array: [itemSettings]))
    }
    
    init(xPosition: Int, yPosition: Int, itemSettingsCollection: ItemSettingsCollection) {
        super.init(
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: "Track.js",
            itemSettingsCollection: itemSettingsCollection)
    }
    
    init(id: Int, xPosition: Int, yPosition: Int, itemSettings: ItemSettings) {
        super.init(
            id: id,
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: "Track.js",
            itemSettingsCollection: ItemSettingsCollection(array: [itemSettings]))
    }
    init(id: Int, xPosition: Int, yPosition: Int, itemSettingsCollection: ItemSettingsCollection) {
        super.init(
            id: id,
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: "Track.js",
            itemSettingsCollection: itemSettingsCollection)
    }
    /*
    var name: String
    var curves: [Curve]?
    var trackSettings: ItemSettings?
    
    
    init(xPosition: Int,
        yPosition: Int,
        name: String,
        divisionSize: Int,
        stepSize: Int,
        startRange: Int,
        endRange: Int,
        scaleType: Int) {
        self.name = name
        self.trackSettings = ItemSettings(
            stepSize: stepSize,
            startRange: startRange,
            endRange: endRange,
            divisionSize: divisionSize,
            scaleType: scaleType)
        super.init(
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: "Track.js",
            itemSettingsCollection: ItemSettingsCollection(array: [trackSettings!]))
        
    }
    
    init(xPosition: Int,
        yPosition: Int,
        name: String,
        trackSettings: ItemSettings,
        curves: [Curve]) {
            self.name = name
            self.trackSettings = trackSettings
            self.curves = curves
            var newItemCurves = [ItemCurve]()
            
            for curve in curves {
                newItemCurves.append(ItemCurve(curveID: curve.id))
            }
            
            super.init(
                xPosition: xPosition,
                yPosition: yPosition,
                jsFileName: "Track.js",
                itemSettingsCollection: ItemSettingsCollection(array: [trackSettings]),
                itemCurves: newItemCurves)
    }
    
    init(id: Int, xPosition: Int,
        yPosition: Int,
        name: String) {
            self.name = name
            super.init(
                id: id,
                xPosition: xPosition,
                yPosition: yPosition,
                jsFileName: "Track.js",
                itemSettingsCollection: ItemSettingsCollection(array: [ItemSettings]()))
    }
    */
}