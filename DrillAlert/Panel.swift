//
//  Panel.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

enum PanelType {
    case Plot, Canvas, Compass, None
    static let allValues = [Plot, Canvas, Compass, None]
    func getTitle() -> String {
        var result = ""
        switch self {
        case Plot:
            result = "Plot"
        case Canvas:
            result = "Canvas"
        case Compass:
            result = "Compass"
        case None:
            result = "None"
        default: result = ""
        }
        
        return result
    }
    
}

class Panel {
    var id: Int?
    var type = PanelType.None
    var name: String
    var position: Int
    var xDimension: Int
    var yDimension: Int
    var visualizations: Array<Visualization>
    var shouldShowDemoPlot = false
    
    init(name: String, position: Int, xDimension: Int, yDimension: Int, visualizations: Array<Visualization>) {
        self.name = name
        self.position = position
        self.xDimension = xDimension
        self.yDimension = yDimension
        self.visualizations = visualizations
    }
    
    init(id: Int, name: String, position: Int, xDimension: Int, yDimension: Int, visualizations: Array<Visualization>, type: String) {
        self.id = id
        self.name = name
        self.position = position
        self.xDimension = xDimension
        self.yDimension = yDimension
        self.visualizations = visualizations
        
        for panelType in PanelType.allValues {
            if panelType.getTitle() == type {
                self.type = panelType
            }
        }
    }
    
    func getVisualizationsJSONString() -> String {
        var JSONString = "["
        
        var index = 0
        
        for visualization in self.visualizations {
            JSONString = JSONString + visualization.toJSONString()
            
            if index < self.visualizations.count - 1{
                JSONString = JSONString + ","
            }
            
            index = index + 1
        }
        
        JSONString = JSONString + "]"
        
        return JSONString
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        
        JSONString = JSONString + "\"Visualizations\": \(self.getVisualizationsJSONString()),"
        JSONString = JSONString + "\"Pos\": 0,"
        JSONString = JSONString + "\"XDim\": 0,"
        JSONString = JSONString + "\"YDim\": 0,"
        JSONString = JSONString + "\"Name\": \"\(self.name)\","
        JSONString = JSONString + "\"Type\": \"\(self.type.getTitle())\""
        
        JSONString = JSONString + "}"
        
        return JSONString
    }
    
    class func getPanelsFromJSONArray(jsonArray: JSONArray) -> Array<Panel> {
        var result = Array<Panel>()
        
        let APIPanelIDKey = "Id"
        let APIPanelNameKey = "Name"
        let APIPanelPositionKey = "Pos"
        let APIPanelXDimensionKey = "XDim"
        let APIPanelYDimensionKey = "YDim"
        let APIPanelVisualizationsKey = "Visualizations"
        let APIPanelTypeKey = "Type"
        
        if let panelJSONs = jsonArray.array {
            for panelJSON in panelJSONs {
                if let id = panelJSON.getIntAtKey(APIPanelIDKey) {
                    if let position = panelJSON.getIntAtKey(APIPanelPositionKey) {
                        if let xDimension = panelJSON.getIntAtKey(APIPanelXDimensionKey) {
                            if let yDimension = panelJSON.getIntAtKey(APIPanelYDimensionKey) {
                                if let name = panelJSON.getStringAtKey(APIPanelNameKey) {
                                    if let type = panelJSON.getStringAtKey(APIPanelTypeKey) {
                                        if let visualizationsJSONArray = panelJSON.getJSONArrayAtKey(APIPanelVisualizationsKey) {
                                            let visualizations = Visualization.getVisualizationsFromJSONArray(visualizationsJSONArray)
                                            
                                            let newPanel = Panel(
                                                id: id,
                                                name: name,
                                                position: position,
                                                xDimension: xDimension,
                                                yDimension: yDimension,
                                                visualizations: visualizations,
                                                type: type
                                            )
                                            result.append(newPanel)
                                        }
                                    }
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