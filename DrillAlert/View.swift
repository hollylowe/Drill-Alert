//
//  View.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/15/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class View {
    
    var name: String
    var visuals: Array<Visual>
    
    
    init(name: String, visuals: Array<Visual>) {
        self.visuals = visuals
        self.name = name
    }
    
    class func getViewsForUser(user: User, andWellbore wellbore: Wellbore) -> Array<View> {
        var result = Array<View>()
        
        var emptyArray = Array<Visual>()
        
        result.append(View(name: "Process X view", visuals: emptyArray))
        result.append(View(name: "Process Y view", visuals: emptyArray))
        
        return result
    }
    
}