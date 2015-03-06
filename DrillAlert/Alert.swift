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

// TODO: Temporary class for getting alerts from
// API. Once we only do API stuff this class
// will probably take over the CoreData class
// below.
class AlertAPI {
    init(id: Int, name: String, rising: Bool, curveID: Int, userID: Int) {
        
    }
    
    class func alertFromJSONObject(JSONObject: JSON) -> AlertAPI? {
        var result: AlertAPI?
        
        // Keys for the Alert
        let APINameKey = "Name"
        let APIAlertIDKey = "Id"
        let APIUserIDKey = "UserId"
        let APIRisingKey = "Rising"
        let APICurveIDKey = "CurveId"
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getIntAtKey(APIAlertIDKey) {
            if let name = JSONObject.getStringAtKey(APINameKey) {
                if let rising = JSONObject.getBoolAtKey(APIRisingKey) {
                    if let curveID = JSONObject.getIntAtKey(APICurveIDKey) {
                        if let userID = JSONObject.getIntAtKey(APIUserIDKey) {
                            let alert = AlertAPI(id: id, name: name, rising: rising, curveID: curveID, userID: userID)
                            result = alert
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    class func getAlertsForUser(user: User) -> (Array<AlertAPI>, String?) {
        var result = Array<AlertAPI>()
        var errorMessage: String?
        
        let url = "https://drillalert.azurewebsites.net/api/alerts"
        if let session = user.userSession {
            let alertsJSONArray = session.getJSONArrayAtURL(url)
            errorMessage = alertsJSONArray.getErrorMessage()
            
            if errorMessage == nil {
                if let alertJSONs = alertsJSONArray.array {
                    for alertJSONObject in alertJSONs {
                        if let alert = AlertAPI.alertFromJSONObject(alertJSONObject) {
                            result.append(alert)
                        }
                    }
                }
            } else {
                // TODO: delete this, only for when the connection doesn't work
                
            }
        }
        
        return (result, errorMessage)
    }
}

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
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var alert = NSEntityDescription.insertNewObjectForEntityForName(Alert.entityName(), inManagedObjectContext: context) as Alert
            alert.alertType = NSNumber(integer: Int(type.rawValue))
            alert.value = NSNumber(float: value)
            alert.isActive = NSNumber(bool: isActive)
            alert.alertPriority = NSNumber(integer: Int(priority.rawValue))
            alert.alertOnRise = NSNumber(bool: alertOnRise)
            
            // Create a UUID
            var uuidObject = CFUUIDCreate(nil)
            var uuidString = CFUUIDCreateString(nil, uuidObject)
            alert.guid = uuidString;
            
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
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var request = NSFetchRequest(entityName: Alert.entityName())
            var error: NSError?
            var results = context.executeFetchRequest(request, error: &error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                allAlerts = results as [Alert]
                
                for alert in allAlerts {
                    println(alert.guid)
                }
            }
        }
        
        return allAlerts
    }
    
    

}
