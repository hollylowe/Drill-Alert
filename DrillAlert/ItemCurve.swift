//
//  ItemCurve.swift
//  DrillAlert
//
//  Created by Lucas David on 5/28/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
class ItemCurve {
    var curveID: String
    var itemID: Int?
    var id: Int?
    
    init(curveID: String) {
        self.curveID = curveID
    }
    
    init(curveID: String, itemID: Int, id: Int) {
        self.curveID = curveID
        self.itemID = itemID
        self.id = id
    }
    
    init(curveID: String, itemID: Int) {
        self.curveID = curveID
        self.itemID = itemID
    }
    
    class func itemCurveFromJSONObject(JSONObject: JSON) -> ItemCurve? {
        var result: ItemCurve?
        var error: String?
        
        // Keys for the Alert
        let APIIDKey = "Id"
        let APIItemIDKey = "ItemId"
        let APICurveIDKey = "CurveId"
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getIntAtKey(APIIDKey) {
            if let itemID = JSONObject.getIntAtKey(APIItemIDKey) {
                if let curveID = JSONObject.getStringAtKey(APICurveIDKey) {
                    result = ItemCurve(curveID: curveID, itemID: itemID, id: id)
                } else {
                    error = "Error creating ItemCurve: Nothing found at \(APICurveIDKey)"
                }
            } else {
                error = "Error creating ItemCurve: Nothing found at \(APIItemIDKey)"
            }
        } else {
            error = "Error creating ItemCurve: Nothing found at \(APIIDKey)"
        }
        
        if (error != nil) {
            println(error)
        }
        
        return result
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        if let id = self.id {
            JSONString = JSONString + " \"Id\": \(id),"
        }
        
        if let itemID = self.itemID {
            JSONString = JSONString + " \"ItemId\": \(itemID),"
        }
        JSONString = JSONString + " \"CurveId\": \"\(self.curveID)\""
        JSONString = JSONString + "}"

        return JSONString

    }
    
    class func getItemCurvesForUser(user: User, andItemID itemID: Int) -> [ItemCurve] {
        var result = Array<ItemCurve>()
        var errorMessage: String?
        
        let url = "https://drillalert.azurewebsites.net/api/itemcurves/\(itemID)"
        let session = user.session
        let itemCurvesJSONArray = session.getJSONArrayAtURL(url)
        errorMessage = itemCurvesJSONArray.getErrorMessage()
        
        if errorMessage == nil {
            if let itemCurveJSONs = itemCurvesJSONArray.array {
                for itemCurveJSONObject in itemCurveJSONs {
                    if let itemCurve = ItemCurve.itemCurveFromJSONObject(itemCurveJSONObject) {
                       result.append(itemCurve)
                    }
                }
            }
        } else {
            // TODO:  Show error message to user
            println("Error: \(errorMessage!)")
        }

        return result
    }
}