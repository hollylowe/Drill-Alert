//
//  Panel.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class Page {
    var id: Int?
    var type = PageType.None
    var name: String
    
    var position: Int!
    var xDimension: Int
    var yDimension: Int
    
    var tracks: [Track]?
    var canvasItems: [CanvasItem]?
    var compass: Compass?
    
    // Plot Initializers
    init(id: Int, name: String, xDimension: Int, yDimension: Int, tracks: [Track]) {
        self.id = id
        self.name = name
        self.xDimension = xDimension
        self.yDimension = yDimension
        self.tracks = tracks
        self.type = .Plot
    }
    init(name: String, xDimension: Int, yDimension: Int, tracks: [Track]) {
        self.name = name
        self.xDimension = xDimension
        self.yDimension = yDimension
        self.tracks = tracks
        self.type = .Plot
    }
    
    // Canvas Initializer
    init(name: String, xDimension: Int, yDimension: Int, canvasItems: [CanvasItem]) {
        self.name = name
        self.xDimension = xDimension
        self.yDimension = yDimension
        self.canvasItems = canvasItems
        self.type = .Canvas
    }
    
    // Compass Initializer
    init(name: String, xDimension: Int, yDimension: Int, compass: Compass) {
        self.name = name
        self.xDimension = xDimension
        self.yDimension = yDimension
        self.compass = compass
        self.type = .Compass
    }
    
    // JSON from API initializer
    init(id: Int, name: String, position: Int, xDimension: Int, yDimension: Int, items: [Item], type: Int) {
        self.id = id
        self.name = name
        self.position = position
        self.xDimension = xDimension
        self.yDimension = yDimension
        
        // TODO: Implement item convert to whichever the type is
        // self.items = items
        if let newType = PageType.pageTypeFromInt(type) {
            self.type = newType
            switch self.type {
            case .Plot:
                self.tracks = [Track]()
                for item in items {
                    // Convert each item into a track
                    if let id = item.id {
                        var track = Track(
                            id: id,
                            xPosition: item.xPosition,
                            yPosition: item.yPosition,
                            itemSettingsCollection: item.itemSettingsCollection)
                       
                        self.tracks!.append(track)
                    } else {
                        println("Warning: Track Item did not have an ID, not creating.")
                    }
                }
            case .Canvas:
                self.canvasItems = [CanvasItem]()
                // Convert each item into a Canvas Item
                for item in items {
                    if let id = item.id {
                        if let type = CanvasItemType.canvasItemTypeFromJSFileName(item.jsFileName) {
                            var canvasItem = CanvasItem(
                                id: id,
                                xPosition: item.xPosition,
                                yPosition: item.yPosition,
                                type: type,
                                name: "Canvas Item \(id)")
                            
                            // Implicit since we just instantiated it above.
                            self.canvasItems!.append(canvasItem)
                        } else {
                            println("Warning: Canvas Item had no Type field for JS File Name '\(item.jsFileName)', not creating.")
                        }
                    } else {
                        println("Warning: Canvas Item had no ID field, not creating.")
                    }
                    
                }
            case .Compass: // TODO: Compass implementation
                println("Compass is not implemented.")
            default: break
            }
        }
    }
    
    func getPlotItemsJSONString() -> String {
        var JSONString = "["
        
        var index = 0
        if let tracks = self.tracks {
            for track in tracks {
                JSONString = JSONString + track.toJSONString()
                
                if index < tracks.count - 1{
                    JSONString = JSONString + ","
                }
                
                index = index + 1
            }
        }
        
        JSONString = JSONString + "]"
        
        return JSONString
    }
    
    func getCanvasItemsJSONString() -> String {
        var JSONString = "["
        
        var index = 0
        if let canvasItems = self.canvasItems {
            for canvasItem in canvasItems {
                JSONString = JSONString + canvasItem.toJSONString()
                
                if index < canvasItems.count - 1{
                    JSONString = JSONString + ","
                }
                
                index = index + 1
            }
        }
        
        JSONString = JSONString + "]"
        
        return JSONString
    }
    
    func getCompassItemsJSONString() -> String {
        // TODO: Implement Compass JSON
        println("Error: Compass JSON Not Implemented.")
        return "[]"
    }
    
    func getItemsJSONString() -> String {
        var result: String!
        
        switch self.type {
        case .Plot: result = self.getPlotItemsJSONString()
        case .Canvas: result = self.getCanvasItemsJSONString()
        case .Compass: result = self.getCompassItemsJSONString()
        default: break
        }
        
        return result
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        
        JSONString = JSONString + "\"Items\": \(self.getItemsJSONString()),"
        
        // Use the Page ID if we have it.
        if let id = self.id {
            JSONString = JSONString + "\"Id\": \(id),"
        }
        
        JSONString = JSONString + "\"Pos\": \(self.position),"
        JSONString = JSONString + "\"XDim\": \(self.xDimension),"
        JSONString = JSONString + "\"YDim\": \(self.yDimension),"
        
        JSONString = JSONString + "\"Name\": \"\(self.name)\","
        JSONString = JSONString + "\"Type\": \(self.type.getInt())"
        
        JSONString = JSONString + "}"
        
        return JSONString
    }
    
    class func pageFromJSON(pageJSON: JSON) -> Page? {
        var result: Page?
        var error: String?
        
        let APIPageIDKey = "Id"
        let APIPositionKey = "Pos"
        let APIXDimensionKey = "XDim"
        let APIYDimensionKey = "YDim"
        
        let APINameKey = "Name"
        let APITypeKey = "Type"
        let APIItemsKey = "Items"
        let APIDashboardIDKey = "DashboardId"
        
        if let id = pageJSON.getIntAtKey(APIPageIDKey) {
            if let position = pageJSON.getIntAtKey(APIPositionKey) {
                if let xDimension = pageJSON.getIntAtKey(APIXDimensionKey) {
                    if let yDimension = pageJSON.getIntAtKey(APIYDimensionKey) {
                        if let name = pageJSON.getStringAtKey(APINameKey) {
                            if let type = pageJSON.getIntAtKey(APITypeKey) {
                                if let dashboardID = pageJSON.getIntAtKey(APIDashboardIDKey) {
                                    if let itemsJSONArray = pageJSON.getJSONArrayAtKey(APIItemsKey) {
                                        let items = Item.getItemsFromJSONArray(itemsJSONArray)
                                        
                                        let newPage = Page(
                                            id: id,
                                            name: name,
                                            position: position,
                                            xDimension: xDimension,
                                            yDimension: yDimension,
                                            items: items,
                                            type: type
                                        )
                                        result = newPage
                                    } else {
                                        error = "Error: Nothing found for Key '\(APIItemsKey)' (Page From JSON)."
                                    }
                                } else {
                                    error = "Error: Nothing found for Key '\(APIDashboardIDKey)' (Page From JSON)."
                                }
                            } else {
                                error = "Error: Nothing found for Key '\(APITypeKey)' (Page From JSON)."
                            }
                        } else {
                            error = "Error: Nothing found for Key '\(APINameKey)' (Page From JSON)."
                        }
                    } else {
                        error = "Error: Nothing found for Key '\(APIYDimensionKey)' (Page From JSON)."
                    }
                } else {
                    error = "Error: Nothing found for Key '\(APIXDimensionKey)' (Page From JSON)."
                }
            } else {
                error = "Error: Nothing found for Key '\(APIPositionKey)' (Page From JSON)."
            }
        } else {
            error = "Error: Nothing found for Key '\(APIPageIDKey)' (Page From JSON)."
        }
        
        if (error != nil) {
            println(error!)
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