//
//  Panel.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

enum PageType {
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

class Page {
    var id: Int?
    var type = PageType.None
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
        
        for pageType in PageType.allValues {
            if pageType.getTitle() == type {
                self.type = pageType
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
    
    class func pageFromJSON(pageJSON: JSON) -> Page? {
        var result: Page?
        
        let APIPanelIDKey = "Id"
        let APIPanelTypeKey = "Type"
        let APIPanelNameKey = "Name"
        let APIPanelPositionKey = "Pos"
        let APIPanelXDimensionKey = "XDim"
        let APIPanelYDimensionKey = "YDim"
        let APIPanelVisualizationsKey = "Visualizations"
        
        if let id = pageJSON.getIntAtKey(APIPanelIDKey) {
            if let position = pageJSON.getIntAtKey(APIPanelPositionKey) {
                if let xDimension = pageJSON.getIntAtKey(APIPanelXDimensionKey) {
                    if let yDimension = pageJSON.getIntAtKey(APIPanelYDimensionKey) {
                        if let name = pageJSON.getStringAtKey(APIPanelNameKey) {
                            if let type = pageJSON.getStringAtKey(APIPanelTypeKey) {
                                if let visualizationsJSONArray = pageJSON.getJSONArrayAtKey(APIPanelVisualizationsKey) {
                                    let visualizations = Visualization.getVisualizationsFromJSONArray(visualizationsJSONArray)
                                    
                                    let newPage = Page(
                                        id: id,
                                        name: name,
                                        position: position,
                                        xDimension: xDimension,
                                        yDimension: yDimension,
                                        visualizations: visualizations,
                                        type: type
                                    )
                                    result = newPage
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    class func getPagesFromJSONArray(jsonArray: JSONArray) -> Array<Page> {
        var result = Array<Page>()
        
        if let pageJSONs = jsonArray.array {
            for pageJSON in pageJSONs {
                if let page = Page.pageFromJSON(pageJSON) {
                    result.append(page)
                }
            }
        }
        
        return result
    }
    
}