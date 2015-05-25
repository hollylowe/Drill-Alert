//
//  Track.swift
//  DrillAlert
//
//  Created by Lucas David on 5/11/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
class Track: Item {
    var name: String
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
        trackSettings: ItemSettings) {
            self.name = name
            self.trackSettings = trackSettings
            super.init(
                xPosition: xPosition,
                yPosition: yPosition,
                jsFileName: "Track.js",
                itemSettingsCollection: ItemSettingsCollection(array: [trackSettings]))
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
}