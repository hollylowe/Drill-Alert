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
    var id: String
    var name: String
    var label: String
    var units: String
    var wellboreID: String?
    var IVT: CurveIVT
    init(id: String, name: String, label: String, units: String, wellboreID: String, IVT: CurveIVT) {
        self.id = id
        self.name = name
        self.label = label
        self.units = units
        self.wellboreID = wellboreID
        self.IVT = IVT
    }
    
    class func getCurvePointCollectionForCurveID(curveID: Int, andWellboreID wellboreID: String, andStartTime startTime: NSDate, andEndTime endTime: NSDate) -> (CurvePointCollection?, String?)  {
        var result: CurvePointCollection?
        var errorMessage: String?
        
        // TODO: Change this to real values
        var endpointURL = "https://drillalert.azurewebsites.net/api/curvepoints/\(curveID)/\(wellboreID)/\(0)/\(0)"
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
    
    func getCurvePointCollectionBetweenStartDate(startDate: NSDate, andEndDate endDate: NSDate) -> (CurvePointCollection?, String?) {
        
        var result: CurvePointCollection?
        var errorMessage: String?
        /*
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
        */
        return (result, errorMessage)
    }
    
    class func getCurvesForUser(user: User, wellbore: Wellbore, fromItemCurves itemCurves: [ItemCurve]) -> (Array<Curve>?, String?) {
        var result: Array<Curve>?
        var finalError: String?
        let (opCurves, opError) = Curve.getCurvesForUser(user, andWellbore: wellbore, andIVT: nil)
        
        // TODO: Get an endpoint for this, 
        // instead of grabbing them all and filtering
        
        if let error = opError {
            finalError = error
            println(error)
        } else if let curves = opCurves {
            result = curves.filter({( curve: Curve) -> Bool in
                for itemCurve in itemCurves {
                    if itemCurve.curveID == curve.id {
                        return true
                    }
                }
                return false
            })
        }
        
        return (result, finalError)
    }
    
    class func getCurvesForUser(user: User, andWellbore wellbore: Wellbore, andIVT opIVT: CurveIVT?) -> (Array<Curve>?, String?) {
        var result: Array<Curve>?
        var errorMessage: String?
        
        var endpointURL = "https://drillalert.azurewebsites.net/api/curves/\(wellbore.id)"
        
        println("Curves URL: " + endpointURL)
        let resultJSONArray = JSONArray(url: endpointURL)
        
        if let resultJSONs = resultJSONArray.array {
            var curveArray = Array<Curve>()
            for resultJSON in resultJSONs {
                if let curve = Curve.curveFromJSONObject(resultJSON, wellbore: wellbore) {
                    if let IVT = opIVT {
                        // Filter out unneeded IVT's
                        if curve.IVT == IVT {
                            curveArray.append(curve)
                        } else {
                            println("Curve does not match IVT (\(curve.IVT) != \(IVT)")
                        }
                    } else {
                        curveArray.append(curve)
                        println("No IVT, appending.")
                    }
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
    
    class func curveFromJSONObject(JSONObject: JSON, wellbore: Wellbore) -> Curve? {
        var result: Curve?
        var error: String?
        
        // Keys for the Alert
        let APICurveIDKey = "Id"
        let APINameKey = "Name"
        let APILabelKey = "Label"
        let APIUnitsKey = "Units"
        let APIWellboreIDKey = "WellboreId"
        let APIIVTKey = "Ivt"
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getStringAtKey(APICurveIDKey) {
            if let name = JSONObject.getStringAtKey(APINameKey) {
                if let label = JSONObject.getStringAtKey(APILabelKey) {
                    if let units = JSONObject.getStringAtKey(APIUnitsKey) {
                        if let IVTInt = JSONObject.getIntAtKey(APIIVTKey) {
                            let IVT = CurveIVT.curveIVTFromInt(IVTInt)
                            result = Curve(
                                id: id,
                                name: name,
                                label: label,
                                units: units,
                                wellboreID: wellbore.id,
                                IVT: IVT)
                        } else {
                            error = "Error creating curve: Nothing found at \(APIIVTKey)"
                        }
                    } else {
                        error = "Error creating curve: Nothing found at \(APIUnitsKey)"
                    }
                } else {
                    error = "Error creating curve: Nothing found at \(APILabelKey)"
                }
            } else {
                error = "Error creating curve: Nothing found at \(APINameKey)"
            }
        } else {
            error = "Error creating curve: Nothing found at \(APICurveIDKey)"
        }
        
        if (error != nil) {
            println(error)
        }
        
        return result
    }
    
    
    
}