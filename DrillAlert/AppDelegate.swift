//
//  AppDelegate.swift
//  DrillAlert
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var userSession: UserSession?
    
    var window: UIWindow?
    // If this is set, we know that we are currently on the Alert Inbox view
    var alertInboxTableViewController: AlertInboxTableViewController?
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        var state = application.applicationState
        
        if state == UIApplicationState.Active {
            let alertController = UIAlertController(
                title: "Drill Alert",
                message: notification.alertBody,
                preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil)
            
            alertController.addAction(defaultAction)
            
            if let window = UIApplication.sharedApplication().keyWindow {
                if let rootViewController = window.rootViewController {
                    rootViewController.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
        return true

    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("Recieved a noti.")
        /*
        var noti = UILocalNotification()
        var body = parameter.name
        noti.fireDate = NSDate(timeInterval: 6, sinceDate: NSDate())
        
        if alert.alertWhenRisesToValue {
            body = body + " on Wellbore 1 has reached \(alert.value)."
        } else {
            body = body + " on Wellbore 1 has fallen to \(alert.value)."
        }
        
        noti.alertBody = body
        noti.timeZone = NSTimeZone.defaultTimeZone()
        UIApplication.sharedApplication().scheduleLocalNotification(noti)
        */
        
        if let alertNotificationAnyObject: AnyObject = userInfo["aps"] {
            if let alertNotificationDictionary = alertNotificationAnyObject as? Dictionary<String, AnyObject> {
                
                if let alertMessage = alertNotificationDictionary["alert"] as? String {
                    if let alertBadge = alertNotificationDictionary["badge"] as? Int {
                        /*
                        if let alertNotification = AlertNotification.createNewInstance("FA07B365-6EBD-4578-8264-A243A6702F20", timeRecieved: NSDate()) {
                            var alertLocalNotification = UILocalNotification()
                            alertLocalNotification.fireDate = NSDate()
                            alertLocalNotification.alertBody = alertMessage
                            UIApplication.sharedApplication().scheduleLocalNotification(alertLocalNotification)
                            
                            if let alertInbox = self.alertInboxTableViewController {
                                alertInbox.recievedRemoteNotification()
                            }
                            
                        }
                        */
                        
                    }
                }
                
                /*
                if let alertGUID = alertNotificationDictionary["alertGUID"] as? String {
                    if let alertNotification = AlertNotification.createNewInstance(alertGUID, timeRecieved: NSDate()) {
                        var alertLocalNotification = UILocalNotification()
                        alertLocalNotification.fireDate = NSDate()
                        alertLocalNotification.alertBody = alertNotification.getNotificationBody()
                        alertLocalNotification.timeZone = NSTimeZone.defaultTimeZone()
                        UIApplication.sharedApplication().scheduleLocalNotification(alertLocalNotification)
                        
                        if let alertInbox = self.alertInboxTableViewController {
                            alertInbox.recievedRemoteNotification()
                        }
                        
                    } else {
                        // If for some reason it didn't save, still alert
                        // the user anyway
                    }
                    
                }
                */
                
            }
        }
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        if let session = self.userSession {
            println("Successfully registered for push notifications.")
            println("Sending token.")
            println(deviceToken.description)
            var token = deviceToken.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
            session.sendDeviceToken(token)
        }
        

    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("Failed to register for push notifications.")
        
        println("Error: ")
        
        println(error)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Drillionaires.DrillAlert" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DrillAlert", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("DrillAlert.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

