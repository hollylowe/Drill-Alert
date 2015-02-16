//
//  WellboreView.swift
//  DrillAlert
//
//  Created by Lucas David on 2/2/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

// drillalert.azurewebsites.net/api/views/7

// [
//    {
//        "Id": 2,
//        "Panels": [
//        {
//          "Id": 2,
//          "Pos": 0,
//          "XDim": 0,
//          "YDim": 0,
//          "Visualizations": [
//              {
//                  "Id": 3,
//                  "XPos": 0,
//                  "YPos": 0,
//                  "JsFile": "Test.js",
//                  "CurveId": 0
//              }
//          ]
//        },
//        {
//          "Id": 3,
//          "Pos": 1,
//          "XDim": 1,
//          "YDim": 0,
//          "Visualizations": [
//              {
//                  "Id": 4,
//                  "XPos": 0,
//                  "YPos": 0,
//                  "JsFile": "Test2.js",
//                  "CurveId": 0
//              }
//          ]
//        }
//      ]
//    }
//]

class Visualization {
    var id: Int
    var xPosition: Int
    var yPosition: Int
    var jsFileName: String
    var curveID: Int
    
    init(id: Int, xPosition: Int, yPosition: Int, jsFileName: String, curveID: Int) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.curveID = curveID
    }
    
    class func getVisualizationsFromJSONArray(jsonArray: JSONArray) -> Array<Visualization> {
        var result = Array<Visualization>()
        
        if let visualizationJSONs = jsonArray.array {
            for visualizationJSON in visualizationJSONs {
                if let id = visualizationJSON.getIntAtKey("Id") {
                    if let xPosition = visualizationJSON.getIntAtKey("XPos") {
                        if let yPosition = visualizationJSON.getIntAtKey("YPos") {
                            if let jsFileName = visualizationJSON.getStringAtKey("JsFile") {
                                if let curveID = visualizationJSON.getIntAtKey("CurveId") {
                                    let newVisualization = Visualization(
                                        id: id,
                                        xPosition: xPosition,
                                        yPosition: yPosition,
                                        jsFileName: jsFileName,
                                        curveID: curveID)
                                    result.append(newVisualization)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
}

class Panel {
    var id: Int
    var position: Int
    var xDimension: Int
    var yDimension: Int
    var visualizations: Array<Visualization>
    
    init(id: Int, position: Int, xDimension: Int, yDimension: Int, visualizations: Array<Visualization>) {
        self.id = id
        self.position = position
        self.xDimension = xDimension
        self.yDimension = yDimension
        self.visualizations = visualizations
    }
    
    
    class func getPanelsFromJSONArray(jsonArray: JSONArray) -> Array<Panel> {
        var result = Array<Panel>()
        
        if let panelJSONs = jsonArray.array {
            for panelJSON in panelJSONs {
                if let id = panelJSON.getIntAtKey("Id") {
                    if let position = panelJSON.getIntAtKey("Pos") {
                        if let xDimension = panelJSON.getIntAtKey("XDim") {
                            if let yDimension = panelJSON.getIntAtKey("YDim") {
                                if let visualizationsJSONArray = panelJSON.getJSONArrayAtKey("Visualizations") {
                                    let visualizations = Visualization.getVisualizationsFromJSONArray(visualizationsJSONArray)
                                    let newPanel = Panel(
                                        id: id,
                                        position: position,
                                        xDimension: xDimension,
                                        yDimension: yDimension,
                                        visualizations: visualizations
                                    )
                                    result.append(newPanel)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
}

class WellboreView {
    var id: Int
    var panels: Array<Panel>

    init(id: Int, panels: Array<Panel>) {
        self.id = id
        self.panels = panels
    }
    
    class func getFakeWellboreViews() -> Array<WellboreView> {
        var visualizations = Array<Visualization>()
        var panels = Array<Panel>()
        
        let newVisualization = Visualization(id: 1, xPosition: 0, yPosition: 0, jsFileName: "non", curveID: 1)
        visualizations.append(newVisualization)
        
        let newPanel = Panel(id: 1, position: 0, xDimension: 0, yDimension: 0, visualizations: visualizations)
        panels.append(newPanel)
        
        let newWellboreView = WellboreView(id: 1, panels: panels)
        var wellboreViews = Array<WellboreView>()
        wellboreViews.append(newWellboreView)
        
        return wellboreViews
    }
    
    class func getWellboreViewsForUserID(userID: String) -> (Array<WellboreView>, String?) {
        var result = Array<WellboreView>()
        var errorMessage: String?
        
        let endpointURL = "http://drillalert.azurewebsites.net/api/views/\(userID)"
        let resultJSONArray = JSONArray(url: endpointURL)
        
        if let resultJSONs = resultJSONArray.array {
            for resultJSON in resultJSONs {
                if let id = resultJSON.getIntAtKey("Id") {
                    if let panelsJSONArray = resultJSON.getJSONArrayAtKey("Panels") {
                        let panels = Panel.getPanelsFromJSONArray(panelsJSONArray)
                        let newWellboreView = WellboreView(id: id, panels: panels)
                        result.append(newWellboreView)
                    }
                }
            }
        } else if let error = resultJSONArray.error {
            errorMessage = WellboreView.getErrorMessageForCode(error.code)
        }
        
        return (result, errorMessage)
    }
    
    class func getErrorMessageForCode(code: Int) -> String? {
        var errorMessage: String?
        
        if code == -1005 {
            errorMessage = "The network connection was lost."
        } else {
            errorMessage = "Unknown Error: \(code)"
        }
        
        return errorMessage
    }
    
}
