//
//  Alert.swift
//  DrillAlert
//
//  Created by Lucas David on 2/16/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Alert {
    var id: Int?
    var userID: Int
    var curveID: Int
    var name: String
    var rising: Bool
    var priority: Priority
    var threshold: Double
    
    let APINameKey       = "Name"
    let APIUserIDKey     = "UserId"
    let APIRisingKey     = "Rising"
    let APIAlertIDKey    = "Id"
    let APICurveIDKey    = "CurveId"
    let APIPriorityKey   = "Priority"
    let APIThresholdKey  = "Threshold"
    let validSaveStatusCode = 200

    init(curveID: Int,
        userID: Int,
        name: String,
        rising: Bool,
        priority: Priority,
        threshold: Double) {
        self.userID = userID
        self.curveID = curveID
        self.name = name
        self.rising = rising
        self.priority = priority
        self.threshold = threshold
    }
    
    init(id: Int,
        curveID: Int,
        userID: Int,
        name: String,
        rising: Bool,
        priority: Priority,
        threshold: Double) {
        self.id = id
        self.userID = userID
        self.curveID = curveID
        self.name = name
        self.rising = rising
        self.priority = priority
        self.threshold = threshold
    }
    
    func save(user: User, completion: ((error: NSError?) -> Void)) {
        let URLString = "https://drillalert.azurewebsites.net/api/Alerts/PostAlert"
        if let URL = NSURL(string: URLString) {
            var newRequest = NSMutableURLRequest(URL: URL)
            newRequest.HTTPMethod = "POST"
            
            var jsonString = ""
            
            if let id = self.id {
                jsonString = "{" +
                    "\"\(self.APIAlertIDKey)\":\(self.id)," +
                    "\"\(self.APINameKey)\":\"\(self.name)\"," +
                    "\"\(self.APIUserIDKey)\":\(self.userID)," +
                    "\"\(self.APIRisingKey)\":\(self.rising)," +
                    "\"\(self.APIThresholdKey)\":\(self.threshold)," +
                    "\"\(self.APICurveIDKey)\":\(self.curveID)," +
                    "\"\(self.APIPriorityKey)\":\(self.priority)" +
                "}"
            } else {
                jsonString = "{" +
                    "\"\(self.APINameKey)\":\"\(self.name)\"," +
                    "\"\(self.APIUserIDKey)\":\(self.userID)," +
                    "\"\(self.APIRisingKey)\":\(self.rising)," +
                    "\"\(self.APIThresholdKey)\":\(self.threshold)," +
                    "\"\(self.APICurveIDKey)\":\(self.curveID)," +
                    "\"\(self.APIPriorityKey)\":\(self.priority)" +
                "}"
            }
            
            
            newRequest.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            newRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            if let session = user.session.session {
                let task = session.dataTaskWithRequest(newRequest, completionHandler: { (data, response, error) -> Void in
                    if let HTTPResponse = response as? NSHTTPURLResponse {
                        let statusCode = HTTPResponse.statusCode
                        if statusCode != self.validSaveStatusCode {
                            // Show error
                            println("Unable to save Alert (\(statusCode)")
                            println("JSON Sent: ")
                            println()
                            println(jsonString)
                            println()
                            println("Data: ")
                            println()
                            println(NSString(data: data, encoding: NSASCIIStringEncoding))
                            
                            let newError = NSError(domain: "com.lucashd.drillalert", code: statusCode, userInfo: nil)
                            completion(error: newError)
                            
                        } else {
                            completion(error: nil)
                        }
                    }
                })
                task.resume()
            }
            
        }
        
    }
    
    class func alertFromJSONObject(JSONObject: JSON, user: User) -> Alert? {
        var result: Alert?
        var error: String?
        
        let APIAlertIDKey   = "Id"
        let APIUserIDKey    = "UserId"
        let APICurveIDKey   = "CurveId"
        let APINameKey      = "Name"
        let APIRisingKey    = "Rising"
        let APIPriorityKey  = "Priority"
        let APIThresholdKey = "Threshold"
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getIntAtKey(APIAlertIDKey) {
            if let curveID = JSONObject.getIntAtKey(APICurveIDKey) {
                if let name = JSONObject.getStringAtKey(APINameKey) {
                    if let rising = JSONObject.getBoolAtKey(APIRisingKey) {
                        if let priorityString = JSONObject.getStringAtKey(APIPriorityKey) {
                            if let priority = Priority.getPriorityForString(priorityString) {
                                if let threshold = JSONObject.getDoubleAtKey(APIThresholdKey) {
                                    if let userID = JSONObject.getIntAtKey(APIUserIDKey) {
                                        let alert = Alert(
                                            curveID: curveID,
                                            userID: userID,
                                            name: name,
                                            rising: rising,
                                            priority: priority,
                                            threshold: threshold)
                                        result = alert
                                    } else {
                                        error = "Error: Could not create alert - No User ID found for alert."
                                    }
                                } else {
                                    error = "Error: Could not create alert - No Threshold found for alert."
                                }
                            } else {
                                error = "Error: Could not create alert - Invalid priority found."
                            }
                        } else {
                            error = "Error: Could not create alert - No Priority found for alert."
                        }
                    } else {
                        error = "Error: Could not create alert - No Rising field found for alert."
                    }
                } else {
                    error = "Error: Could not create alert: No Name field found for alert."
                }
            } else {
                error = "Error: Could not create alert: No Curve ID found for alert."
            }
        } else {
            error = "Error: Could not create alert: No ID found for alert."
        }
        
        if (error != nil) {
            println(error)
        }
        
        return result
    }
    
    class func getAllAlertsForUser(user: User) -> (Array<Alert>, String?) {
        var result = Array<Alert>()
        var errorMessage: String?
        
        let url = "https://drillalert.azurewebsites.net/api/alerts"
        let session = user.session
        let alertsJSONArray = session.getJSONArrayAtURL(url)
        errorMessage = alertsJSONArray.getErrorMessage()
        
        if errorMessage == nil {
            if let alertJSONs = alertsJSONArray.array {
                for alertJSONObject in alertJSONs {
                    if let alert = Alert.alertFromJSONObject(alertJSONObject, user: user) {
                        // TODO: 
                        result.append(alert)
                    }
                }
            }
        } else {
            // TODO:  Show error message to user
            
        }
        
        
        return (result, errorMessage)
    }
    
    class func getAlertsForUser(user: User, andWellbore wellbore: Wellbore) -> (Array<Alert>, String?) {
        var result = Array<Alert>()
        var errorMessage: String?
        
        let url = "https://drillalert.azurewebsites.net/api/alerts"
        let session = user.session
        let alertsJSONArray = session.getJSONArrayAtURL(url)
        errorMessage = alertsJSONArray.getErrorMessage()
        
        if errorMessage == nil {
            if let alertJSONs = alertsJSONArray.array {
                for alertJSONObject in alertJSONs {
                    if let alert = Alert.alertFromJSONObject(alertJSONObject, user: user) {
                        // TODO: Get an actual endpoint for this,
                        // instead of retrieving all alerts and filtering
                        
                        /*
                        if alert.wellboreID == wellbore.id {
                            result.append(alert)
                        }
                        */
                    }
                }
            }
        } else {
            // TODO:  Show error message to user
            
        }
        
        
        return (result, errorMessage)
    }
}

