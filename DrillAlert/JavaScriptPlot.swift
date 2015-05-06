//
//  JavaScriptPlot.swift
//  DrillAlert
//
//  Created by Lucas David on 5/6/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class JavaScriptPlot: JavaScriptVisualization {
    var id: Int
    var yMax: Int
    var xMax: Int
    var initialData = Array<Int>()
    var width: Int
    var height: Int
    
    init(id: Int, yMax: Int, xMax: Int, initialData: Array<Int>, width: Int, height: Int) {
        self.id = id
        self.yMax = yMax
        self.xMax = xMax
        self.initialData = initialData
        self.width = width
        self.height = height
    }
    
    private func getInitialDataString() -> String {
        var dataString = "["
        var dataCount = 0
        if self.initialData.count > 0 {
            for dataPoint in self.initialData {
                dataString = dataString + "\(dataPoint)"
                if dataCount != self.initialData.count - 1 {
                    dataString = dataString + ", "
                }
                dataCount = dataCount + 1
            }
        }
        
        
        dataString = dataString + "]"
        return dataString
    }
    
    func getInitializerJavaScriptString() -> String! {
        var plotInitializer = "master.init("
        var config = "{id: \(self.id), yMax: \(self.yMax), xMax: \(self.xMax), width: \(self.width), height: \(self.height), data: \(self.getInitialDataString())}"
        
        plotInitializer = plotInitializer + config + ")"
        return plotInitializer
    }
    
    func getTickJavaScriptStringWithDataPoint(dataPoint: NSNumber) -> String! {
        let tickString = "master.tick(\(dataPoint.stringValue), \(self.id))"
        return tickString
    }
    
}
