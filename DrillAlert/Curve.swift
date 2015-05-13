//
//  Curve.swift
//  DrillAlert
//
//  Created by Lucas David on 2/2/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class CurvePointCollection {
    var curveID: Int
    var wellboreID: Int
    var curvePoints: Array<CurvePoint>
    
    init(curveID: Int, wellboreID: Int) {
        self.curveID = curveID
        self.wellboreID = wellboreID
        self.curvePoints = Array<CurvePoint>()
    }
    
    init(curveID: Int, wellboreID: Int, curvePoints: Array<CurvePoint>) {
        self.curveID = curveID
        self.wellboreID = wellboreID
        self.curvePoints = curvePoints
    }
    
    class func curvePointCollectionFromJSONObject(JSONObject: JSON) -> CurvePointCollection? {
        var result: CurvePointCollection?
        
        if let wellboreID = JSONObject.getIntAtKey("wellboreId") {
            if let curveID = JSONObject.getIntAtKey("curveId") {
                
                // Now get each curve point.
                if let data = JSONObject.getJSONArrayAtKey("data") {
                    var curvePoints = Array<CurvePoint>()
                    
                    if let curvePointJSONs = data.array {
                        for curvePointJSON in curvePointJSONs {
                            if let curvePoint = CurvePoint.curvePointFromJSON(curvePointJSON) {
                                curvePoints.append(curvePoint)
                            }
                        }
                    }
                    
                    result = CurvePointCollection(curveID: curveID, wellboreID: wellboreID, curvePoints: curvePoints)
                }
            }
        }
        
        return result
    }
}

class CurvePoint {
    var value: Float
    var time: Int // TODO: Change to Date eventually
    
    init(value: Float, time: Int) {
        self.value = value
        self.time = time
    }
    
    class func curvePointFromJSON(curvePointJSON: JSON) -> CurvePoint? {
        var result: CurvePoint?
        
        if let curvePointValue = curvePointJSON.getFloatAtKey("value") {
            if let curvePointTime = curvePointJSON.getStringAtKey("time") {
                result = CurvePoint(value: curvePointValue, stringTime: curvePointTime)
            }
        }
        
        return result
    }
    
    init(value: Float, stringTime: String) {
        self.value = value
        if let newTime = stringTime.toInt() {
            self.time = newTime
        } else {
            self.time = 0
        }
    }
}

class Curve {
    var id: Int
    var name: String
    var tooltype: String
    var units: String
    var wellbore: Wellbore
    init(id: Int, name: String, tooltype: String, units: String, wellbore: Wellbore) {
        self.id = id
        self.name = name
        self.tooltype = tooltype
        self.units = units
        self.wellbore = wellbore
    }
    
    func getCurvePointCollectionBetweenStartDate(startDate: NSDate, andEndDate endDate: NSDate) -> (CurvePointCollection?, String?) {
        var result: CurvePointCollection?
        var errorMessage: String?
        
        // TODO: Change this to real values
        let startTime = 0
        let endTime = 0
        
        var endpointURL = "https://drillalert.azurewebsites.net/api/curvepoints/\(self.id)/\(self.wellbore.id)/\(startTime)/\(endTime)"
        println(endpointURL)
        let resultJSONArray = JSONArray(url: endpointURL)
        
        if let resultJSONs = resultJSONArray.array {
            // There should only be one 
            if resultJSONs.count > 0 {
                let curvePointCollectionJSON = resultJSONs[0]
                result = CurvePointCollection.curvePointCollectionFromJSONObject(curvePointCollectionJSON)
            }
        } else {
            if let error = resultJSONArray.error {
                errorMessage = error.description
                println("Error while getting CurvePointCollection: ")
                println(errorMessage)
                println()
            }
        }
        
        return (result, errorMessage)
    }
    
    class func getCurvesForUser(user: User, andWellbore wellbore: Wellbore) -> (Array<Curve>?, String?) {
        var result: Array<Curve>?
        var errorMessage: String?
        
        var endpointURL = "https://drillalert.azurewebsites.net/api/curves/\(wellbore.id)"
        
        println("Curves: " + endpointURL)
        let resultJSONArray = JSONArray(url: endpointURL)
        
        if let resultJSONs = resultJSONArray.array {
            var curveArray = Array<Curve>()
            for resultJSON in resultJSONs {
                if let curve = Curve.curveFromJSONObject(resultJSON, user: user, wellbore: wellbore) {
                    curveArray.append(curve)
                }
            }
            
            result = curveArray
        } else {
            if let error = resultJSONArray.error {
                errorMessage = error.description
                println("Error while getting Curves: ")
                println(errorMessage)
                println()
            }
        }
        
        return (result, errorMessage)
    }
    
    class func curveFromJSONObject(JSONObject: JSON, user: User, wellbore: Wellbore) -> Curve? {
        var result: Curve?
        // Keys for the Alert
        let APICurveIDKey = "Id"
        let APINameKey = "Name"
        let APIToolTypeKey = "ToolType"
        let APIUnitsKey = "Units"
        
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getIntAtKey(APICurveIDKey) {
            if let name = JSONObject.getStringAtKey(APINameKey) {
                if let tooltype = JSONObject.getStringAtKey(APIToolTypeKey) {
                    if let units = JSONObject.getStringAtKey(APIUnitsKey) {
                        result = Curve(id: id, name: name, tooltype: tooltype, units: units, wellbore: wellbore)
                    }
                }
            }
        }
        
        return result
    }
    
    
    
}