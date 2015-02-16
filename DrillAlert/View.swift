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
    var currentView: Bool
    
    
    init(name: String, visuals: Array<Visual>, currentView: Bool) {
        self.currentView = currentView
        self.visuals = visuals
        self.name = name
    }
    
    class func getViewsForUser(user: User, andWellbore wellbore: Wellbore) -> Array<View> {
        var result = Array<View>()
        
        var emptyArray = Array<Visual>()
        
        result.append(View(name: "Process X view", visuals: emptyArray, currentView: true))
        result.append(View(name: "Process Y view", visuals: emptyArray, currentView: false))
        result.append(View(name: "My favorite view", visuals: emptyArray, currentView: false))

        
        return result
    }
    
    func equals (other: View) -> Bool {
        return (self.name == (other.name as String))
    }
    
}