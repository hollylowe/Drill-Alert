//
//  JavaScriptGauge.swift
//  DrillAlert
//
//  Created by Lucas David on 5/6/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class JavaScriptGauge: JavaScriptVisualization {
    
    var id: Int // id is required and is the identifier of the plot. (Should be unique)
    var size: Int = 300 // size is the diameter of the whole gauge in px
    var clipWidth: Int = 300 // the width of the div containing the gauge in px
    var clipHeight: Int = 300 // the height of the div containing the gauge in px
    var ringWidth: Int = 60 // how thick(wide) the color spectrum part of the gauge in px
    var maxValue: Int = 10  // the maximum value the gauge can reach
    var transitionMs: Int = 4000 // the time it takes to transition from one value to the next in milliseconds
    
    init(id: Int, size: Int, clipWidth: Int, clipHeight: Int, ringWidth: Int, maxValue: Int, transitionMs: Int) {
        self.id = id
        self.size = size
        self.clipWidth = clipWidth
        self.clipHeight = clipHeight
        self.ringWidth = ringWidth
        self.maxValue = maxValue
        self.transitionMs = transitionMs
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func getInitializerJavaScriptString() -> String! {
        var gaugeInitializer = "masterGauge.init("
        let config = "{id: \(self.id), size: \(self.size), clipWidth: \(self.clipWidth), clipHeight: \(self.clipHeight), ringWidth: \(self.ringWidth), maxValue: \(self.maxValue), transitionMs: \(self.transitionMs)}"
        
        gaugeInitializer = gaugeInitializer + config + ")"
        
        return gaugeInitializer
    }
    
    func getTickJavaScriptStringWithDataPoint(dataPoint: NSNumber) -> String! {
        let tickString = "masterGauge.update(\(dataPoint.stringValue), \(self.id))"
        return tickString
    }
    
    
}