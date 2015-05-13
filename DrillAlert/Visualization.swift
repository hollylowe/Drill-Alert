//
//  Visualization.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class Visualization {
    var id: Int?
    var xPosition: Int
    var yPosition: Int
    var jsFileName: String
    var curveIDs: [Int]?
    
    init(xPosition: Int, yPosition: Int, jsFileName: String) {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
    }
    
    init(id: Int, xPosition: Int, yPosition: Int, jsFileName: String, curveIDs: Array<Int>) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.curveIDs = curveIDs
    }
    
    class func getVisualizationFromJSON(visualizationJSON: JSON) -> Visualization? {
        var result: Visualization?
        if let id = visualizationJSON.getIntAtKey("Id") {
            if let xPosition = visualizationJSON.getIntAtKey("XPos") {
                if let yPosition = visualizationJSON.getIntAtKey("YPos") {
                    if let jsFileName = visualizationJSON.getStringAtKey("JsFile") {
                       if let curveIDs = visualizationJSON.getIntArrayAtKey("CurveIds") {
                        // TODO: Curve IDS are not implemented yet, using fake data [1]
                            let newVisualization = Visualization(
                                id: id,
                                xPosition: xPosition,
                                yPosition: yPosition,
                                jsFileName: jsFileName,
                                curveIDs: curveIDs)
                            result = newVisualization
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    class func getVisualizationsFromJSONArray(jsonArray: JSONArray) -> Array<Visualization> {
        var result = Array<Visualization>()
        
        if let visualizationJSONs = jsonArray.array {
            for visualizationJSON in visualizationJSONs {
                if let visualization = Visualization.getVisualizationFromJSON(visualizationJSON) {
                    result.append(visualization)
                }
            }
        }
        
        return result
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        
        JSONString = JSONString + "\"XPos\": \(self.xPosition),"
        JSONString = JSONString + "\"YPos\": \(self.yPosition),"
        JSONString = JSONString + "\"JsFile\": \"\(self.jsFileName)\","
        JSONString = JSONString + "\"PanelId\": 0,"
        
        if let curveIDs = self.curveIDs {
            JSONString = JSONString + "\"CurveIds\": ["
            var curveIDIndex = 1
            for curveID in curveIDs {
                JSONString = JSONString + "\(curveID)"
                
                if curveIDIndex < curveIDs.count {
                    JSONString = JSONString + ","
                }
                
                curveIDIndex = curveIDIndex + 1
            }
            JSONString = JSONString + "]"
        } else {
            JSONString = JSONString + "\"CurveIds\": null"
        }
        JSONString = JSONString + "}"
        
        return JSONString
    }
    
    
}
