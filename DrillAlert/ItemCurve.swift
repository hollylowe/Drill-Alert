//
//  ItemCurve.swift
//  DrillAlert
//
//  Created by Lucas David on 5/28/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
class ItemCurve {
    var curve: Curve?
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
    
    func postToBackendForUser(user: User, withCallback callback: ((error: String?) -> Void)) {
        if let itemID = self.itemID {
            let URLString = "https://drillalert.azurewebsites.net/api/itemcurves/\(itemID)"
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                
                if let URL = NSURL(string: URLString) {
                    let JSONString = "[" + self.toJSONString() + "]"
                    println("The ItemCurve JSON: " )
                    println(JSONString)
                    if let postData = JSONString.dataUsingEncoding(NSASCIIStringEncoding) {
                        let request = NSMutableURLRequest(URL: URL)
                        
                        let contentTypeValue = "application/x-www-form-urlencoded"
                        let contentTypeHeader = "Content-Type"
                        let acceptHeader = "Accept"
                        let acceptValue = "application/json"
                        let contentLengthValue = String(postData.length)
                        let contentLengthHeader = "Content-Length"
                        request.HTTPMethod = "PUT"
                        request.HTTPBody = postData
                        request.setValue(
                            contentLengthValue,
                            forHTTPHeaderField: contentLengthHeader)
                        request.setValue(
                            contentTypeValue,
                            forHTTPHeaderField: contentTypeHeader)
                        request.setValue(
                            acceptValue,
                            forHTTPHeaderField: acceptHeader)
                        
                        if let session = user.session {
                            let task = session.session!.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    if error != nil {
                                        println("Error when saving item curves : \(error.description)")
                                        callback(error: "Unable to save item curve (\(error.description)).")
                                    } else {
                                        println("Saved item curve.")
                                        println("Response: \(response)")
                                        let dataString = NSString(data: data, encoding: NSASCIIStringEncoding)
                                        
                                        println("Data: \(dataString)")
                                        println("Error: \(error)")
                                        // callback(error: nil)
                                        callback(error: nil)
                                    }
                                })
                            })
                            task.resume()
                        } else {
                            callback(error: "Error: No session found for user.")
                        }
                        
                    } else {
                        callback(error: "Error: Could not get post data.")
                    }
                } else {
                    callback(error: "Error: Not a valid URL.")
                }
            })
        } else {
            callback(error: "Error: No Item ID given.")
        }
        
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
        
        if user.shouldUseFixtureData {
            result.append(ItemCurve(curveID: "0", itemID: 0, id: 0))
        } else {
            let url = "https://drillalert.azurewebsites.net/api/itemcurves/\(itemID)"
            if let userSDISession = user.session {
                let itemCurvesJSONArray = userSDISession.getJSONArrayAtURL(url)
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
            }
        }
        

        return result
    }
}