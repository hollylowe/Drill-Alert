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
    var yMin: Int = 0
    var xMin: Int = 0
    var titleSize: Int = 0
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
        /* var dataString = "["
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
        */
        return "[0, 1, 2, 3, 4,5,6,7,8,9,10,11,12,13]"
        // return dataString
    }
    
    private func getInitialIDataString() -> String {
        return "[]"
    }
    
    /*
        config = {yMin: 0,
        yMax : 10,
        xMin: 0,
        xMax : 10,
        data : [1, 2, 3, 4, 5,2,3,4,5,2,7,3,6,8],
        idata: [0, 1, 2, 3, 4,5,6,7,8,9,10,11,12,13],
        width : 500,
        height : 300,
        title : "Inclination",
        units : "deg/time",
        titleSize : 20,
        id : 0}

    */
    
    func getInitializerJavaScriptString() -> String! {
        var plotInitializer = "master.init("
        var config = "{id: \(self.id), "
        config = config + "yMin: \(self.yMin),"
        config = config + "xMin: \(self.xMin),"
        config = config + "yMax: \(self.yMax),"
        config = config + "title : \"Inclination\","
        config = config + "units : \"deg/time\","

        config = config + "xMax: \(self.xMax),"
        config = config + "titleSize: \(self.titleSize), "
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
        return "master.tick(\(curvePoint.value), \(curvePoint.IV), \(self.id))"
    }
}
