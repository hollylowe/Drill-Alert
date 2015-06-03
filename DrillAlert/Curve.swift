//
//  Curve.swift
//  DrillAlert
//
//  Created by Lucas David on 2/2/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class CurvePointCollection {
    var curveID: String
    var wellboreID: String
    var curvePoints: Array<CurvePoint>
    
    init(curveID: String, wellboreID: String) {
        self.curveID = curveID
        self.wellboreID = wellboreID
        self.curvePoints = Array<CurvePoint>()
    }
    
    init(curveID: String, wellboreID: String, curvePoints: Array<CurvePoint>) {
        self.curveID = curveID
        self.wellboreID = wellboreID
        self.curvePoints = curvePoints
    }
    
    class func curvePointCollectionFromJSONObject(JSONObject: JSON) -> CurvePointCollection? {
        var result: CurvePointCollection?
        
        if let wellboreID = JSONObject.getStringAtKey("wellboreId") {
            if let curveID = JSONObject.getStringAtKey("curveId") {
                
                // Now get each curve point.
                if let data = JSONObject.getJSONArrayAtKey("data") {
                    var curvePoints = Array<CurvePoint>()
                    
                    if let curvePointJSONs = data.array {
                        for curvePointJSON in curvePointJSONs {
                            if let curvePoint = CurvePoint.curvePointFromJSON(curvePointJSON) {
                                curvePoints.append(curvePoint)
                            } else {
                                println("Error: Could not get curve point from JSON.")
                            }
                        }
                    } else {
                        println("Error: No curve point JSON data array.")
                    }
                    result = CurvePointCollection(
                        curveID: curveID,
                        wellboreID: wellboreID,
                        curvePoints: curvePoints)
                } else {
                    println("Error: No data found for cpc.")
                }
            } else {
                println("Error: No curve id found for curve point collection.")
            }
        } else {
            println("Error: No wellbore id found for curve point collection.")
        }
        
        return result
    }
}

class CurvePoint {
    var value: Int
    var IV: Int
    
    init(value: Int, IV: Int) {
        self.value = value
        self.IV = IV
    }
    
    class func curvePointFromJSON(curvePointJSON: JSON) -> CurvePoint? {
        var result: CurvePoint?
        
        if let curvePointValue = curvePointJSON.getIntAtKey("value") {
            if let curvePointIV = curvePointJSON.getIntAtKey("iv") {
                result = CurvePoint(value: curvePointValue, IV: curvePointIV)
            } else {
                println("Error: Could not get curve point iv.")
            }
        } else {
            println("Error: Could not get curve point value.")
        }
        
        return result
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
    
    class func getCurvePointCollectionForUser(user: User, curveID: String, startIV: Int, andEndIV endIV: Int) -> (CurvePointCollection?, String?)  {
        var result: CurvePointCollection?
        var errorMessage: String?
        if user.shouldUseFixtureData {
           result = CurvePointCollection(
            curveID: "",
            wellboreID: "",
            curvePoints: [CurvePoint(value: 0, IV: 0)])
        } else {
            // TODO: Change this to real time values
            
            var endpointURL = "https://drillalert.azurewebsites.net/api/curvepoints/\(curveID)/\(startIV)/\(endIV)"
            if let curvePointCollectionJSON = JSON.JSONFromURL(endpointURL) {
                result = CurvePointCollection.curvePointCollectionFromJSONObject(curvePointCollectionJSON)
            } else {
                errorMessage = "Error: No result JSON array."
                
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
    
    class func addCurvesToItemCurves(itemCurves: [ItemCurve], user: User, andWellbore wellbore: Wellbore) -> ([ItemCurve]?, String?) {
        var result: Array<ItemCurve>?
        var error: String?
        
        if user.shouldUseFixtureData {
            result = Array<ItemCurve>()
            let testCurve = Curve(
                id: "0",
                name: "Test Curve",
                label: "Label",
                units: "Units",
                wellboreID: "0",
                IVT: CurveIVT.Depth)
            let testItemCurve = ItemCurve(curveID: "0", itemID: 0, id: 0)
            testItemCurve.curve = testCurve
            result!.append(testItemCurve)
        } else {
            let (opCurves, opError) = Curve.getCurvesForUser(user, andWellbore: wellbore, andIVT: nil)
            
            // TODO: Get an endpoint for this,
            // instead of grabbing them all and filtering
            
            if opError == nil {
                result = Array<ItemCurve>()
                // Curves are all the curves
                // this user has access to. We need 
                // to filter through each curve and grab the 
                // ones that this item curve corresponds to.
                if let curves = opCurves {
                    
                    for curve in curves {
                        for itemCurve in itemCurves {
                            if itemCurve.curveID == curve.id {
                                if let itemID = itemCurve.itemID {
                                    if let id = itemCurve.id {
                                        let newItemCurve = ItemCurve(
                                            curveID: itemCurve.curveID,
                                            itemID: itemID,
                                            id: id)
                                        newItemCurve.curve = curve
                                        result!.append(newItemCurve)

                                    }
                                }
                            }
                        }
                    }
                } else {
                    error = "No error, but no curves were found."
                }
            } else {
                error = opError!
            }
        }
        
        return (result, error)
    }
    
    class func getCurvesForUser(user: User, wellbore: Wellbore, fromItemCurves itemCurves: [ItemCurve]) -> (Array<Curve>?, String?) {
        var result: Array<Curve>?
        var finalError: String?
        
        if user.shouldUseFixtureData {
            result = Array<Curve>()
            result!.append(Curve(id: "0", name: "Test Curve", label: "Label", units: "Units", wellboreID: "0", IVT: CurveIVT.Depth))
        } else {
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
                            itemCurve.curve = curve
                            return true
                        }
                    }
                    return false
                })
            }
        }
        
        
        return (result, finalError)
    }
    
    class func getCurvesForUser(user: User, andWellbore wellbore: Wellbore, andIVT opIVT: CurveIVT?) -> (Array<Curve>?, String?) {
        var result: Array<Curve>?
        var errorMessage: String?
        
        if user.shouldUseFixtureData {
            result = Array<Curve>()
            result!.append(Curve(id: "0", name: "Test Curve", label: "Label", units: "Units", wellboreID: "0", IVT: CurveIVT.Depth))
        } else {
            var endpointURL = "https://drillalert.azurewebsites.net/api/curves/\(wellbore.id)"
            
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