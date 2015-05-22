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
    var page: Page
    
    init(id: Int, yMax: Int, xMax: Int, initialData: Array<Int>, width: Int, height: Int, page: Page) {
        self.id = id
        self.yMax = yMax
        self.xMax = xMax
        self.initialData = initialData
        self.width = width
        self.height = height
        self.page = page
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
    
    private func getInitialIDataString() -> String {
        return "[]"
    }
    
    func getInitializerJavaScriptString() -> String! {
        var plotInitializer = "master.init("
        var config = "{id: \(self.id), "
            
        config = config + "yMax: \(self.yMax), "
        config = config + "xMax: \(self.xMax), "
        config = config + "width: \(self.width), "
        config = config + "height: \(self.height), "
        config = config + "data: \(self.getInitialDataString()), "
        config = config + "idata: \(self.getInitialIDataString())"
        config = config + "}"
        
        plotInitializer = plotInitializer + config + ")"
        return plotInitializer
    }
    
    func getTickJavaScriptStringWithDataPoint(dataPoint: NSNumber) -> String! {
        let tickString = "master.tick(\(dataPoint.stringValue), 10, \(self.id))"
        return tickString
    }
    
    func getTickJavaScriptStringWithCurvePoint(curvePoint: CurvePoint) -> String! {
        return "master.tick(\(curvePoint.value), \(curvePoint.time), \(self.id))"
    }
}
