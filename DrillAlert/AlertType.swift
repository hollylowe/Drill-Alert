//
//  AlertType.swift
//  DrillAlert
//
//  Created by Lucas David on 2/16/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

// This should probably be on the server instead of a constant enum. 

enum AlertType: Int {
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
import CoreData

class AlertType: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var unit: String

}

*/