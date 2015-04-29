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
    var wellboreID: Int
    var severity: Severity
    var threshold: Double
    
    // Keys for the Alert
    let APIUserIDKey = "UserId"
    let APIAlertIDKey = "Id"
    let APICurveIDKey = "CurveId"
    let APINameKey = "Name"
    let APIRisingKey = "Rising"
    
    let APIWellboreIDKey = "WellBoreId"
    let APISeverityKey = "Priority"
    let APIThresholdKey = "Threshold"
    let validSaveStatusCode = 200

    init(curveID: Int, userID: Int, name: String, rising: Bool, wellboreID: Int, severity: Severity, threshold: Double) {
        self.userID = userID
        self.curveID = curveID
        self.name = name
        self.rising = rising
        self.wellboreID = wellboreID
        self.severity = severity
        self.threshold = threshold
    }
    
    init(id: Int, curveID: Int, userID: Int, name: String, rising: Bool, wellboreID: Int, severity: Int, threshold: Double) {
        self.id = id
        self.userID = userID
        self.curveID = curveID
        self.name = name
        self.rising = rising
        self.wellboreID = wellboreID
        
        if let newSeverity = Severity(rawValue: severity) {
            self.severity = newSeverity
        } else {
            self.severity = Severity.None
        }
        
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
                    "\"\(self.APISeverityKey)\":\(self.severity.rawValue)," +
                    "\"\(self.APIWellboreIDKey)\":\(self.wellboreID)" +
                "}"
            } else {
                jsonString = "{" +
                    "\"\(self.APINameKey)\":\"\(self.name)\"," +
                    "\"\(self.APIUserIDKey)\":\(self.userID)," +
                    "\"\(self.APIRisingKey)\":\(self.rising)," +
                    "\"\(self.APIThresholdKey)\":\(self.threshold)," +
                    "\"\(self.APICurveIDKey)\":\(self.curveID)," +
                    "\"\(self.APISeverityKey)\":\(self.severity.rawValue)," +
                    "\"\(self.APIWellboreIDKey)\":\(self.wellboreID)" +
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
        // Keys for the Alert
        let APIAlertIDKey = "Id"
        let APICurveIDKey = "CurveId"
        let APINameKey = "Name"
        let APIRisingKey = "Rising"
        let APIUserIDKey = "UserId"
        
        let APIWellboreIDKey = "WellBoreId"
        let APISeverityKey = "Priority"
        let APIThresholdKey = "Threshold"
        
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getIntAtKey(APIAlertIDKey) {
            if let curveID = JSONObject.getIntAtKey(APICurveIDKey) {
                if let name = JSONObject.getStringAtKey(APINameKey) {
                    if let rising = JSONObject.getBoolAtKey(APIRisingKey) {
                        if let wellboreID = JSONObject.getIntAtKey(APIWellboreIDKey) {
                            if let severityInt = JSONObject.getIntAtKey(APISeverityKey) {
                                if let threshold = JSONObject.getDoubleAtKey(APIThresholdKey) {
                                    let alert = Alert(
                                        id: id,
                                        curveID: curveID,
                                        userID: user.id,
                                        name: name,
                                        rising: rising,
                                        wellboreID: wellboreID,
                                        severity: severityInt,
                                        threshold: threshold)
                                    
                                    result = alert
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    // GET api/Alerts
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
                        if alert.wellboreID == wellbore.id {
                            result.append(alert)
                        }
                    }
                }
            }
        } else {
            // TODO:  Show error message to user
            
        }
        
        
        return (result, errorMessage)
    }
}

/*
@objc(Alert)
class Alert: NSManagedObject {

    @NSManaged var value: NSNumber
    @NSManaged var isActive: NSNumber
    @NSManaged var alertOnRise: NSNumber
    @NSManaged var alertType: NSNumber
    @NSManaged var alertPriority: NSNumber
    @NSManaged var guid: String
    
    func getAlertType() -> AlertType? {
        var result: AlertType?
        
        for alertType in AlertType.allValues {
            if alertType.rawValue == self.alertType.integerValue {
                result = alertType
                break
            }
        }
        
        return result
    }
    
    func getAlertPriority() -> AlertPriority? {
        var result: AlertPriority?
        
        for alertPriority in AlertPriority.allValues {
            if alertPriority.rawValue == self.alertPriority.integerValue {
                result = alertPriority
                break
            }
        }
        
        return result
    }
    
    func setAlertType(alertType: AlertType) {
        self.alertType = NSNumber(integer: Int(alertType.rawValue))
    }
    
    func setAlertPriority(alertPriority: AlertPriority) {
        self.alertPriority = NSNumber(integer: Int(alertPriority.rawValue))
    }
    
    func save() -> Bool {
        var success = false
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let context = appDelegate.managedObjectContext {
            var error: NSError?
            context.save(&error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                success = true
            }
        }
        
        return success
    }
    
    class func entityName() -> String {
        return "Alert"
    }
    
    class func createNewInstance(value: Float, isActive: Bool, alertOnRise: Bool, type: AlertType, priority: AlertPriority) -> Alert? {
        var newAlert: Alert?
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let context = appDelegate.managedObjectContext {
            var alert = NSEntityDescription.insertNewObjectForEntityForName(Alert.entityName(), inManagedObjectContext: context) as! Alert
            alert.alertType = NSNumber(integer: Int(type.rawValue))
            alert.value = NSNumber(float: value)
            alert.isActive = NSNumber(bool: isActive)
            alert.alertPriority = NSNumber(integer: Int(priority.rawValue))
            alert.alertOnRise = NSNumber(bool: alertOnRise)
            
            // Create a UUID
            var uuidObject = CFUUIDCreate(nil)
            var uuidString = CFUUIDCreateString(nil, uuidObject)
            
            // TODO: Change this
            // alert.guid = uuidString;
            
            var error: NSError?
            
            context.save(&error)
            
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                newAlert = alert
            }
        }
        
        return newAlert
    }
    
    
    class func fetchAllInstances() -> Array<Alert> {
        var allAlerts = Array<Alert>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let context = appDelegate.managedObjectContext {
            var request = NSFetchRequest(entityName: Alert.entityName())
            var error: NSError?
            var results = context.executeFetchRequest(request, error: &error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                allAlerts = results as! [Alert]
                
                for alert in allAlerts {
                    println(alert.guid)
                }
            }
        }
        
        return allAlerts
    }
}
*/
