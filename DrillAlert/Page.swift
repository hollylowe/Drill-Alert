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
    var position: Int
    var xDimension: Int
    var yDimension: Int
    var items: [Item]
    var shouldShowDemoPlot = false
    
    init(name: String, position: Int, xDimension: Int, yDimension: Int, items: [Item]) {
        self.name = name
        self.position = position
        self.xDimension = 300
        self.yDimension = 500
        self.items = items
    }
    
    init(id: Int, name: String, position: Int, xDimension: Int, yDimension: Int, items: [Item], type: Int) {
        self.id = id
        self.name = name
        self.position = position
        self.xDimension = 300
        self.yDimension = 500
        self.items = items
        
        if let newType = PageType.pageTypeFromInt(type) {
            self.type = newType
        }
    }
    
    func getItemsJSONString() -> String {
        var JSONString = "["
        
        var index = 0
        
        for item in self.items {
            JSONString = JSONString + item.toJSONString()
            
            if index < self.items.count - 1{
                JSONString = JSONString + ","
            }
            
            index = index + 1
        }
        
        JSONString = JSONString + "]"
        
        return JSONString
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        // TODO: Use actual pos/xdim/ydim
        JSONString = JSONString + "\"Items\": \(self.getItemsJSONString()),"
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
        
        let APIPageIDKey = "Id"
        let APIPositionKey = "Pos"
        let APIXDimensionKey = "XDim"
        let APIYDimensionKey = "YDim"
        
        let APINameKey = "Name"
        let APITypeKey = "Type"
        let APIItemsKey = "Items"
        
        if let id = pageJSON.getIntAtKey(APIPageIDKey) {
            if let position = pageJSON.getIntAtKey(APIPositionKey) {
                if let xDimension = pageJSON.getIntAtKey(APIXDimensionKey) {
                    if let yDimension = pageJSON.getIntAtKey(APIYDimensionKey) {
                        if let name = pageJSON.getStringAtKey(APINameKey) {
                            if let type = pageJSON.getIntAtKey(APITypeKey) {
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