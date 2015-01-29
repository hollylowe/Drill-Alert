//
//  AlertType.swift
//  DrillAlert
//
//  Created by Lucas David on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

enum AlertType {
    case Temperature, Angle, Azimuth, Inclination, Pressure
    
    var units : String {
        switch self {
        case .Temperature: return "degrees"
        case .Angle: return "degrees"
        case .Azimuth: return "degrees"
        case .Inclination: return "degrees"
        case .Pressure: return "force per unit"
        }
    }
    
    var name : String {
        switch self {
        case .Temperature: return "Temperature"
        case .Angle: return "Angle"
        case .Azimuth: return "Azimuth"
        case .Inclination: return "Inclination"
        case .Pressure: return "Pressure"
        }
    }
    
    static let allValues = [Temperature, Angle, Azimuth, Inclination, Pressure]
}

/* 

We might want a class if this is ever to be
put on the server as a configurable option. For
now, an enum should be just fine.

class AlertType {
    var name: String
    var units: String
    
    init(name: String, units: String) {
        self.name = name
        self.units = units
    }
    
    class func getAllAlertTypes() -> Array<AlertType> {
        var result = Array<AlertType>()
        
        result.append(AlertType(name: "Temperature", units: "degrees"))
        result.append(AlertType(name: "Angle", units: "degrees"))
        result.append(AlertType(name: "Azimuth", units: "degrees"))
        result.append(AlertType(name: "Inclination", units: "degrees"))
        result.append(AlertType(name: "Pressure", units: "force per unit")) // N/m ^ 2
        
        return result
    }
}

*/
