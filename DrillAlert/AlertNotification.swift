//
//  AlertNotification.swift
//  DrillAlert
//
//  Created by Lucas David on 2/18/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(AlertNotification)
class AlertNotification: NSManagedObject {

    @NSManaged var timeRecieved: NSDate
    @NSManaged var read: NSNumber
    @NSManaged var alert: Alert

    func delete() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            context.deleteObject(self)
            var error: NSError?
            
            context.save(&error)
            
            if error != nil {
                println("Core Data Error: ")
                println(error)
            }
        }
    }
    
    func getNotificationBody() -> String {
        var body = ""
        
        if let alertType = self.alert.getAlertType() {
            if let alertPriority = self.alert.getAlertPriority() {
                body = body + alertType.name
                
                if self.alert.alertOnRise.boolValue {
                    body = body + " has risen to "
                } else {
                    body = body + " has fallen to "
                }
                
                body = body + self.alert.value.stringValue + " \(alertType.units)"
                
            }
        }
        
        return body
    }
    
    
    class func entityName() -> String {
        return "AlertNotification"
    }
    
    class func createNewInstance(alertGUID: String, timeRecieved: NSDate) -> AlertNotification? {
        var newAlertNotification: AlertNotification?
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var alertNotification = NSEntityDescription.insertNewObjectForEntityForName(AlertNotification.entityName(), inManagedObjectContext: context) as AlertNotification
            
            alertNotification.read = NSNumber(bool: false)
            alertNotification.timeRecieved = timeRecieved
            
            let alertFetchRequest = NSFetchRequest(entityName: Alert.entityName())
            let alertPredicate = NSPredicate(format: "guid == %@", argumentArray: [alertGUID])
            
            alertFetchRequest.predicate = alertPredicate
            
            if let alertFetchResults = context.executeFetchRequest(alertFetchRequest, error: nil) as? [Alert] {
                if alertFetchResults.count > 0 {
                    alertNotification.alert = alertFetchResults[0]
                }
            }
            
            var error: NSError?
            
            context.save(&error)
            
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                newAlertNotification = alertNotification
                println(newAlertNotification)
            }
        }
        
        return newAlertNotification
    }
    
    class func fetchAllInstances() -> Array<AlertNotification> {
        var allAlertNotifications = Array<AlertNotification>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var request = NSFetchRequest(entityName: AlertNotification.entityName())
            var error: NSError?
            var results = context.executeFetchRequest(request, error: &error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                allAlertNotifications = results as [AlertNotification]
            }
        }
        
        return allAlertNotifications
    }
    
    class func fetchAllReadAlertNotifications() -> Array<AlertNotification> {
        var result = Array<AlertNotification>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var request = NSFetchRequest(entityName: AlertNotification.entityName())
            var predicate = NSPredicate(format: "read == %@", argumentArray: [NSNumber(bool: true)])
            request.predicate = predicate
            
            var error: NSError?
            var results = context.executeFetchRequest(request, error: &error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                result = results as [AlertNotification]
            }
        }
        
        return result
    }
    
    class func fetchAllAlertNotificationsWithPriority(alertPriority: AlertPriority) -> Array<AlertNotification> {
        var result = Array<AlertNotification>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var request = NSFetchRequest(entityName: AlertNotification.entityName())
            var predicate = NSPredicate(format: "(alert.alertPriority == %@) AND (read == %@)", argumentArray: [NSNumber(integer: Int(alertPriority.rawValue)), NSNumber(bool: false)])
            request.predicate = predicate
            
            var error: NSError?
            var results = context.executeFetchRequest(request, error: &error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                result = results as [AlertNotification]
            }
        }
        
        return result
    }
    
    class func fetchAllCriticalAlertNotifications() -> Array<AlertNotification> {
        return AlertNotification.fetchAllAlertNotificationsWithPriority(AlertPriority.Critical)
    }
    
    class func fetchAllWarningAlertNotifications() -> Array<AlertNotification> {
        return AlertNotification.fetchAllAlertNotificationsWithPriority(AlertPriority.Warning)
    }
    
    class func fetchAllInformationAlertNotifications() -> Array<AlertNotification> {
        return AlertNotification.fetchAllAlertNotificationsWithPriority(AlertPriority.Information)
    }
    
    func markAsRead() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            self.read = NSNumber(bool: true)
            var error: NSError?
            context.save(&error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            }
        }
    }
    
    func unmarkAsRead() {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            self.read = NSNumber(bool: false)
            var error: NSError?
            context.save(&error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            }
        }
    }
    
}
