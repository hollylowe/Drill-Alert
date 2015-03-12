//
//  FavoriteWell.swift
//  DrillAlert
//
//  Created by Lucas David on 3/11/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(FavoriteWellbore)
class FavoriteWellbore : NSManagedObject {
    
    @NSManaged var wellboreID: NSNumber
    
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
    
    class func fetchAllInstances() -> Array<FavoriteWellbore> {
        var allFavoriteWellbores = Array<FavoriteWellbore>()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var request = NSFetchRequest(entityName: FavoriteWellbore.entityName())
            var error: NSError?
            var results = context.executeFetchRequest(request, error: &error)
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                allFavoriteWellbores = results as [FavoriteWellbore]
            }
        }
        
        return allFavoriteWellbores
    }
    
    class func createNewInstance(wellboreID: Int) -> FavoriteWellbore? {
        var newFavoriteWellbore: FavoriteWellbore?
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            var favoriteWellbore = NSEntityDescription.insertNewObjectForEntityForName(FavoriteWellbore.entityName(), inManagedObjectContext: context) as FavoriteWellbore
            
            favoriteWellbore.wellboreID = NSNumber(integer: wellboreID)
            
            var error: NSError?
            
            context.save(&error)
            
            if error != nil {
                println("Core Data Error: ")
                println(error)
            } else {
                newFavoriteWellbore = favoriteWellbore
            }
        }
        
        return newFavoriteWellbore
    }

    class func fetchFavoriteWellboreWithWellboreID(wellboreID: Int) -> FavoriteWellbore? {
        var favoriteWellbore: FavoriteWellbore?
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context = appDelegate.managedObjectContext {
            
            let favoriteWellboreFetchRequest = NSFetchRequest(entityName: FavoriteWellbore.entityName())
            let favoriteWellborePredicate = NSPredicate(format: "wellboreID == %@", argumentArray: [NSNumber(integer: wellboreID)])
            
            favoriteWellboreFetchRequest.predicate = favoriteWellborePredicate
            
            if let favoriteWellboreFetchResults = context.executeFetchRequest(favoriteWellboreFetchRequest, error: nil) as? [FavoriteWellbore] {
                if favoriteWellboreFetchResults.count > 0 {
                    favoriteWellbore = favoriteWellboreFetchResults[0]
                }
            }
        }
        
        return favoriteWellbore
    }
    
    class func entityName() -> String {
        return "FavoriteWellbore"
    }
}