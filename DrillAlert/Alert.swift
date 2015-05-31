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
    var curveID: String
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

    init(curveID: String,
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
        curveID: String,
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
    
    func toJSONString() -> String {
        var jsonString = "{"
        if let id = self.id {
            jsonString = jsonString + "\"\(self.APIAlertIDKey)\":\(id),"
        }
        
        jsonString = jsonString + "\"\(self.APINameKey)\":\"\(self.name)\"," +
            "\"\(self.APIUserIDKey)\":\(self.userID)," +
            "\"\(self.APIRisingKey)\":\(self.rising)," +
            "\"\(self.APIThresholdKey)\":\(self.threshold)," +
            "\"\(self.APICurveIDKey)\":\"\(self.curveID)\"," +
            "\"\(self.APIPriorityKey)\":\"\(self.priority.toString())\"" + "}"
        
        return jsonString
    }
    
    func save(user: User,
        completion: ((error: NSError?) -> Void)) {
        
            if user.shouldUseFixtureData {
                println("Using fixture data, will not send alert.")
                println("The JSON:")
                println(self.toJSONString())
                completion(error: nil)
            } else {
                var URLString: String!
                
                if let id = self.id {
                    URLString = "https://drillalert.azurewebsites.net/api/alerts/\(id)"
                } else {
                    URLString = "https://drillalert.azurewebsites.net/api/alerts/PostAlert"
                }
                
                if let URL = NSURL(string: URLString) {
                    var newRequest = NSMutableURLRequest(URL: URL)
                    if let id = self.id {
                        newRequest.HTTPMethod = "PUT"
                    } else {
                        newRequest.HTTPMethod = "POST"
                    }
                    
                    var jsonString = self.toJSONString()
                    
                    newRequest.HTTPBody = jsonString.dataUsingEncoding(
                        NSUTF8StringEncoding, allowLossyConversion: true)
                    newRequest.setValue("application/json; charset=utf-8",
                        forHTTPHeaderField: "Content-Type")
                    if let userSDISession = user.session {
                        if let session = userSDISession.session {
                            let task = session.dataTaskWithRequest(newRequest, completionHandler: { (data, response, error) -> Void in
                                if let HTTPResponse = response as? NSHTTPURLResponse {
                                    let statusCode = HTTPResponse.statusCode
                                    if statusCode != self.validSaveStatusCode {
                                        // Show error
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
            if let curveID = JSONObject.getStringAtKey(APICurveIDKey) {
                if let name = JSONObject.getStringAtKey(APINameKey) {
                    if let rising = JSONObject.getBoolAtKey(APIRisingKey) {
                        if let priorityString = JSONObject.getStringAtKey(APIPriorityKey) {
                            if let priority = Priority.getPriorityForString(priorityString) {
                                if let threshold = JSONObject.getDoubleAtKey(APIThresholdKey) {
                                    if let userID = JSONObject.getIntAtKey(APIUserIDKey) {
                                        let alert = Alert(
                                            id: id,
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
        
        if user.shouldUseFixtureData {
            let testAlert = Alert(id: 0, curveID: "0", userID: user.id, name: "Test Alert", rising: true, priority: Priority.Critical, threshold: 1.0)
            result.append(testAlert)
        } else {
            let url = "https://drillalert.azurewebsites.net/api/alerts"
            if let session = user.session {
                let alertsJSONArray = session.getJSONArrayAtURL(url)
                errorMessage = alertsJSONArray.getErrorMessage()
                
                if errorMessage == nil {
                    if let alertJSONs = alertsJSONArray.array {
                        for alertJSONObject in alertJSONs {
                            if let alert = Alert.alertFromJSONObject(alertJSONObject, user: user) {
                                result.append(alert)
                            }
                        }
                    }
                } else {
                    // TODO:  Show error message to user
                    println("Error while getting alerts: \(errorMessage!)")
                }
            }
        }
        
        return (result, errorMessage)
    }
    
    class func getAlertsForUser(user: User, andWellbore wellbore: Wellbore) -> (Array<Alert>, String?) {
        var result = Array<Alert>()
        var errorMessage: String?
        
        if user.shouldUseFixtureData {
            let (alerts, error) = Alert.getAllAlertsForUser(user)
            result = alerts
        } else {
            let (newCurves, curvesError) = wellbore.getCurves(user)
            if curvesError == nil {
                // There can only be alerts if there are curves
                // on this wellbore to support them.
                // Only retrieve alerts if we have at least one curve.
                if newCurves.count > 0 {
                    let url = "https://drillalert.azurewebsites.net/api/alerts"
                    if let userSDISession = user.session {
                        let alertsJSONArray = userSDISession.getJSONArrayAtURL(url)
                        errorMessage = alertsJSONArray.getErrorMessage()
                        
                        if errorMessage == nil {
                            if let alertJSONs = alertsJSONArray.array {
                                for alertJSONObject in alertJSONs {
                                    if let alert = Alert.alertFromJSONObject(alertJSONObject, user: user) {
                                        // TODO: Get an actual endpoint for this,
                                        // instead of retrieving all alerts and filtering
                                        
                                        // TODO: Use a faster method for filtering through curves
                                        // by ID if there is no endpoint for it
                                        for curve in newCurves {
                                            if alert.curveID == curve.id {
                                                result.append(alert)
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            // TODO:  Show error message to user
                            println("Error: \(errorMessage!)")
                        }
                    }
                } else {
                    println("Warning: Retrived curves, but there were none.")
                }
            } else {
                println("Error: \(curvesError)")
                errorMessage = curvesError
            }
        }
        
        
        
        return (result, errorMessage)
    }
}

