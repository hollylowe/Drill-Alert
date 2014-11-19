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
    
    init(name: String) {
        self.name = name
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
}