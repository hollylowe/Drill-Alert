//
//  Visual.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/15/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class Visual {
    
    var name: String
    var type: VisualType
    
    
    init(type: VisualType, name: String) {
        self.type = type
        self.name = name
    }
    
    class func getVisualsForUser(user: User, andWellbore wellbore: Wellbore) -> Array<Visual> {
        var result = Array<Visual>()
        
        result.append(Visual(type: .Plot, name: "My Favorite Plot"))
        result.append(Visual(type: .Gauge, name: "Pressure Gauge"))
            
        return result
    }

}