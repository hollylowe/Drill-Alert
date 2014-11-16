//
//  Well.swift
//  DrillAlert
//
//  Created by Lucas David on 11/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class Well {
    var name: String
    var wellbores = Array<Wellbore>()
    
    init(name: String) {
        self.name = name
    }
    
    /// This is an API call to get all of the wells 
    /// as an array from the server. Used in the Admin 
    /// view.
    class func getAllWells() -> Array<Well> {
        var wells = Array<Well>()
        
        // Using canned data
        wells.append(Well(name: "Well 1"))
        wells.append(Well(name: "Well 2"))
        wells.append(Well(name: "Well 3"))
        wells.append(Well(name: "Well 4"))
        wells.append(Well(name: "Well 5"))

        return wells
    }
    
    /// Gets all of the users that have access to 
    /// this well.
    func getUsers() -> Array<User> {
        var users = Array<User>()
        
        // Using canned data
        users.append(User(firstName: "Lucas", lastName: "David", id: "123"))
        users.append(User(firstName: "Another", lastName: "User", id: "117"))
        
        return users
    }

}