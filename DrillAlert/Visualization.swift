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
    
    init(id: Int, xPosition: Int, yPosition: Int, jsFileName: String) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
    }
    
    class func getVisualizationsFromJSONArray(jsonArray: JSONArray) -> Array<Visualization> {
        var result = Array<Visualization>()
        
        if let visualizationJSONs = jsonArray.array {
            for visualizationJSON in visualizationJSONs {
                if let id = visualizationJSON.getIntAtKey("Id") {
                    if let xPosition = visualizationJSON.getIntAtKey("XPos") {
                        if let yPosition = visualizationJSON.getIntAtKey("YPos") {
                            if let jsFileName = visualizationJSON.getStringAtKey("JsFile") {
                                //if let curveID = visualizationJSON.getIntAtKey("CurveId") {
                                    let newVisualization = Visualization(
                                        id: id,
                                        xPosition: xPosition,
                                        yPosition: yPosition,
                                        jsFileName: jsFileName)
                                    result.append(newVisualization)
                                //}
                            }
                        }
                    }
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
        JSONString = JSONString + "\"CurveIds\": null"
        
        JSONString = JSONString + "}"
        
        return JSONString
    }
    
    
}
