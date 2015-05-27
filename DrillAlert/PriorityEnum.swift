//
//  PriorityEnum.swift
//  DrillAlert
//
//  Created by Lucas David on 5/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation



enum Priority: Int {
    case Information = 0
    case Warning = 1
    case Critical = 2
    case None = 9
    
    func toString() -> String {
        var result: String!
        
        switch self {
        case Information:
            result = "Information"
        case Warning:
            result = "Warning"
        case Critical:
            result = "Critical"
        case None:
            result = "None"
            
        }
        
        return result
    }
    
    static func getPriorityForString(string: String) -> Priority? {
        var result: Priority?
        
        switch string {
        case Information.toString():
            result = Information
        case Warning.toString():
            result = Warning
        case Critical.toString():
            result = Critical
        default: break
        }
        
        return result
    }
}