//
//  ItemSettings.swift
//  DrillAlert
//
//  Created by Lucas David on 5/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class ItemSettingsCollection {
    var array: [ItemSettings]
    
    init(array: [ItemSettings]) {
        self.array = array
    }
    
    class func getItemSettingsCollectionFromJSONArray(JSONArrayObject: JSONArray) -> ItemSettingsCollection {
        var result = Array<ItemSettings>()
        
        if JSONArrayObject.error == nil {
            if let array = JSONArrayObject.array {
                for JSONObject in array {
                    if let itemSettings = ItemSettings.getItemSettingsFromJSONObject(JSONObject) {
                        result.append(itemSettings)
                    }
                }
            }
        } else {
            println("Error creating ItemSettingsCollection: \(JSONArrayObject.error)")
        }
        
        return ItemSettingsCollection(array: result)
    }
}

class ItemSettings {
    var itemID: Int?
    var id: Int?
    var stepSize: Int
    var startRange: Int
    var endRange: Int
    var divisionSize: Int
    var scaleType: Int
    
    init(itemID: Int, id: Int, stepSize: Int, startRange: Int, endRange: Int, divisionSize: Int, scaleType: Int) {
        self.itemID = itemID
        self.id = id
        self.stepSize = stepSize
        self.startRange = startRange
        self.endRange = endRange
        self.divisionSize = divisionSize
        self.scaleType = scaleType
    }
    
    init(stepSize: Int, startRange: Int, endRange: Int, divisionSize: Int, scaleType: Int) {
        self.stepSize = stepSize
        self.startRange = startRange
        self.endRange = endRange
        self.divisionSize = divisionSize
        self.scaleType = scaleType
    }
    
    class func getItemSettingsFromJSONObject(JSONObject: JSON) -> ItemSettings? {
        var result: ItemSettings?
        var error: String?
        
        let APIItemIDKey = "ItemId"
        let APIIDKey = "Id"
        let APIStepSizeKey = "StepSize"
        let APIStartRangeKey = "StartRange"
        let APIEndRangeKey = "EndRange"
        let APIDivisionSizeKey = "DivisionSize"
        let APIScaleTypeKey = "ScaleType"
        
        if let id = JSONObject.getIntAtKey(APIIDKey) {
            if let itemID = JSONObject.getIntAtKey(APIItemIDKey) {
                if let stepSize = JSONObject.getIntAtKey(APIStepSizeKey) {
                    if let startRange = JSONObject.getIntAtKey(APIStartRangeKey) {
                        if let endRange = JSONObject.getIntAtKey(APIEndRangeKey) {
                            if let divisionSize = JSONObject.getIntAtKey(APIDivisionSizeKey) {
                                if let scaleType = JSONObject.getIntAtKey(APIScaleTypeKey) {
                                    result = ItemSettings(
                                        itemID: itemID,
                                        id: id,
                                        stepSize: stepSize,
                                        startRange: startRange,
                                        endRange: endRange,
                                        divisionSize: divisionSize,
                                        scaleType: scaleType)
                                } else {
                                    error = "Error creating ItemSettings: Nothing found at \(APIScaleTypeKey) key."
                                }
                            } else {
                                error = "Error creating ItemSettings: Nothing found at \(APIDivisionSizeKey) key."
                            }
                        } else {
                            error = "Error creating ItemSettings: Nothing found at \(APIEndRangeKey) key."
                        }
                    } else {
                        error = "Error creating ItemSettings: Nothing found at \(APIStartRangeKey) key."
                    }
                } else {
                    error = "Error creating ItemSettings: Nothing found at \(APIStepSizeKey) key."
                }
            } else {
                error = "Error creating ItemSettings: Nothing found at \(APIItemIDKey) key."
            }
        } else {
            error = "Error creating ItemSettings: Nothing found at \(APIIDKey) key."
        }
        
        if (error != nil) {
            println(error)
        }
        
        return result
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        
        if let id = self.id {
            JSONString = JSONString + "\"Id\": \(id),"
        }
        
        if let itemID = self.itemID {
            JSONString = JSONString + "\"ItemId\": \(itemID),"
        }
        
        JSONString = JSONString + "\"StepSize\": \(self.stepSize),"
        JSONString = JSONString + "\"StartRange\": \(self.startRange),"
        JSONString = JSONString + "\"EndRange\": \(self.endRange),"
        JSONString = JSONString + "\"DivisionSize\": \(self.divisionSize),"
        JSONString = JSONString + "\"ScaleType\": \(self.scaleType)"
        JSONString = JSONString + "}"
        
        return JSONString

    }
    
}