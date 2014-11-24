//
//  Wellbore.swift
//  DrillAlert
//
//  Created by Lucas David on 11/8/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class Wellbore {
    var name: String!
    var data: Array<Int>!
    var titles: Array<String>!
    var res: AnyObject!
    
    init(name: String) {
        self.name = name
        self.data = [200, 350]
        self.titles = ["\"blue\"", "\"more blue\""]
        
//        let url = NSURL(string: "http://drillalert.azurewebsites.net/api/WellboreData/5")
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            self.data = NSString(data: data, encoding: NSUTF8StringEncoding)!
//            let fullNameArr = self.data.componentsSeparatedByString("(")
//            self.data = fullNameArr[0]
//            println(self.data)
//        }
//        
//        task.resume()
    }
    
    /// An API call to get all of the wellbores a user
    /// is subscribed to.
    class func getSubscribedWellboresForUserID(userID: String) -> Array<Wellbore> {
        var wellbores = Array<Wellbore>()
        
        // Using canned data
        wellbores.append(Wellbore(name: "Wellbore 1"))
        wellbores.append(Wellbore(name: "Wellbore 3"))
        
        return wellbores
    }
    
    /// An API call to get all of the wellbores a user has
    /// access to.
    class func getAllWellboresForUserID(userID: String) -> Array<Wellbore> {
        var wellbores = Array<Wellbore>()
        
        // Using canned data
        wellbores.append(Wellbore(name: "Wellbore 1"))
        wellbores.append(Wellbore(name: "Wellbore 3"))
        wellbores.append(Wellbore(name: "Wellbore 4"))
        
        return wellbores
    }
    
    func getData() -> Array<Int>{
        return self.data
    }
    
    func getTitles() -> Array<String>{
        return self.titles
    }
}