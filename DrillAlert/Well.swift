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
    
    init(name: String) {
        self.name = name
    }
    
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
    
    class func getSubscribedWellsForUserID(userID: String) -> Array<Well> {
        var wells = Array<Well>()
        
        // Using canned data
        wells.append(Well(name: "Well 1"))
        wells.append(Well(name: "Well 3"))
        
        return wells
    }
    
    class func getAllWellsForUserID(userID: String) -> Array<Well> {
        var wells = Array<Well>()
        
        // Using canned data
        wells.append(Well(name: "Well 1"))
        wells.append(Well(name: "Well 3"))
        wells.append(Well(name: "Well 4"))
        
        return wells
    }
}