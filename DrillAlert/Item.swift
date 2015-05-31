//
//  Visualization.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class Item {
    var id: Int?
    var xPosition: Int
    var yPosition: Int
    var jsFileName: String
    var itemSettingsCollection: ItemSettingsCollection
    var itemCurves = [ItemCurve]()
    
    init(xPosition: Int, yPosition: Int, jsFileName: String) {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.itemSettingsCollection = ItemSettingsCollection(array: [])
    }
    
    init(xPosition: Int, yPosition: Int, jsFileName: String, itemSettingsCollection: ItemSettingsCollection) {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.itemSettingsCollection = itemSettingsCollection
    }
    
    init(xPosition: Int, yPosition: Int, jsFileName: String, itemSettingsCollection: ItemSettingsCollection, itemCurves: [ItemCurve]) {
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.itemSettingsCollection = itemSettingsCollection
        self.itemCurves = itemCurves
    }
    
    init(id: Int, xPosition: Int, yPosition: Int, jsFileName: String) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.itemSettingsCollection = ItemSettingsCollection(array: [])
    }
    
    init(id: Int, xPosition: Int, yPosition: Int, jsFileName: String, itemSettingsCollection: ItemSettingsCollection) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.itemSettingsCollection = itemSettingsCollection
    }
    
    init(id: Int, xPosition: Int, yPosition: Int, jsFileName: String, itemSettingsCollection: ItemSettingsCollection, itemCurves: [ItemCurve]) {
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.jsFileName = jsFileName
        self.itemSettingsCollection = itemSettingsCollection
        self.itemCurves = itemCurves
    }
    
    class func getItemFromJSON(itemJSON: JSON) -> Item? {
        var result: Item?
        var error: String?
        
        let APIItemIDKey = "Id"
        let APIItemXPosKey = "XPos"
        let APIItemYPosKey = "YPos"
        let APIItemJSFileKey = "JsFile"
        let APIItemPageIDKey = "PageId"
        let APIItemSettingsKey = "ItemSettings"
        
        if let id = itemJSON.getIntAtKey(APIItemIDKey) {
            if let xPosition = itemJSON.getIntAtKey(APIItemXPosKey) {
                if let yPosition = itemJSON.getIntAtKey(APIItemYPosKey) {
                    if let jsFileName = itemJSON.getStringAtKey(APIItemJSFileKey) {
                        if let itemSettingsJSONArray = itemJSON.getJSONArrayAtKey(APIItemSettingsKey) {
                            
                            var itemSettingsCollection = ItemSettingsCollection.getItemSettingsCollectionFromJSONArray(itemSettingsJSONArray)
                            
                            let newItem = Item(
                                id: id,
                                xPosition: xPosition,
                                yPosition: yPosition,
                                jsFileName: jsFileName,
                                itemSettingsCollection: itemSettingsCollection)
                            
                            result = newItem
                            
                        } else {
                            let newItem = Item(
                                id: id,
                                xPosition: xPosition,
                                yPosition: yPosition,
                                jsFileName: jsFileName)
                            
                            result = newItem
                            
                            error = "Warning: Nothing found at \(APIItemSettingsKey) key for item \(id)."
                        }
                    } else {
                        error = "Error creating Item: Nothing found at \(APIItemJSFileKey) key."
                    }
                } else {
                    error = "Error creating Item: Nothing found at \(APIItemYPosKey) key."
                }
            } else {
                error = "Error creating Item: Nothing found at \(APIItemXPosKey) key."
            }
        } else {
            error = "Error creating Item: Nothing found at \(APIItemIDKey) key."
        }
        
        if (error != nil) {
            println(error!)
        }
        
        return result
    }
    
    class func getItemsFromJSONArray(jsonArray: JSONArray) -> [Item] {
        var result = [Item]()
        
        if let itemJSONs = jsonArray.array {
            for itemJSON in itemJSONs {
                if let item = Item.getItemFromJSON(itemJSON) {
                    result.append(item)
                }
            }
        }
        
        return result
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        
        if let id = self.id {
            JSONString = JSONString + "\"Id\": \(id),"
        }
        
        JSONString = JSONString + "\"XPos\": \(self.xPosition),"
        JSONString = JSONString + "\"YPos\": \(self.yPosition),"
        JSONString = JSONString + "\"JsFile\": \"\(self.jsFileName)\","
        JSONString = JSONString + "\"ItemSettings\": ["

        for itemSettings in itemSettingsCollection.array {
            JSONString = JSONString + itemSettings.toJSONString()
        }
        
        JSONString = JSONString + "]}"
        
        
        return JSONString
    }
    
    
}
