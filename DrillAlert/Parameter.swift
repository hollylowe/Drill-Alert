//
//  Parameter.swift
//  DrillAlert
//
//  Created by Lucas David on 11/29/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class Parameter {
    var name: String!
    
    init(name: String) {
        self.name = name
    }
    
    class func getAllParameters() -> Array<Parameter> {
        var result = Array<Parameter>()
        
        // TODO: Use real data
        result.append(Parameter(name: "Angle"))
        result.append(Parameter(name: "Azimuth"))
        result.append(Parameter(name: "Inclination"))
        result.append(Parameter(name: "Pressure"))
        result.append(Parameter(name: "Temperature"))
        result.append(Parameter(name: "Vibration"))
        
        return result
    }
}