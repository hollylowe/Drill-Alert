//
//  AlertPriority.swift
//  DrillAlert
//
//  Created by Lucas David on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation



/*

We might want a class if this is ever to be 
put on the server as a configurable option. For
now, an enum should be fine.

class AlertPriority {
    var name: String
    var rank: Int
    
    init(name: String, rank: Int) {
        self.rank = rank
        self.name = name
    }
    
    class func getAllAlertPriorities() -> Array<AlertPriority> {
        var result = Array<AlertPriority>()
        
        result.append(AlertPriority(name: "Critical", rank: 0))
        result.append(AlertPriority(name: "Warning", rank: 1))
        result.append(AlertPriority(name: "Information", rank: 2))
        
        return result
    }
}

*/