//
//  AlertPriority.swift
//  DrillAlert
//
//  Created by Lucas David on 2/16/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

// This is an enum for now, I was about to put 
// it in CoreData, but I'm not sure if that is 
// neccessary.

enum AlertPriority : Int {
    case Critical = 0, Warning = 1, Information = 2
    
    var description : String {
        switch self {
        case .Critical: return "Critical"
        case .Warning: return "Warning"
        case .Information: return "Information"
        }
    }
    
    static let allValues = [Critical, Warning, Information]

}

/*
import CoreData
import UIKit

class AlertPriority: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var rank: NSNumber

    class func entityName() -> String {
        return "AlertPriority"
    }
    
    
    class func updateSavedAlertPriorities() -> Array<AlertPriority> {
        
    }
    
    // Returns all the instances of the
    // AlertPriorties. This can be saved on the
    // device, but updated via the API whenever a
    // user goes to view the priorities.
    class func fetchAllInstances() -> Array<AlertPriority> {
        var allAlertPriorities = Array<AlertPriority>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var request = NSFetchRequest(entityName: AlertPriority.entityName())
            var error: NSError?
            var results = context.executeFetchRequest(request, error: &error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                allAlertPriorities = results as [AlertPriority]
                
                // If there aren't any saved priorities, we 
                // need to get them from the API (if they 
                // are going to be stored on the server) or 
                // from our own enum. 
                // 
                // If they are stored on the server, then 
                // they can be configured down the line. 
                // 
                // If they aren't, they will always have these
                // same alert priorities.
                if allAlertPriorities.count == 0 {
                    allh
                }
            }
        }
        
        return allAlertPriorities
    }
}

*/
