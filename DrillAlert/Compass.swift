//
//  Compass.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

enum CompassSensorType {
    case Gyroscopic
    static let allValues = [Gyroscopic]
    
    func getTitle() -> String {
        var result = ""
        
        switch self {
        case Gyroscopic: result = "Gyroscopic"
        default: result = ""
        }
        
        return result
    }
}

enum CompassDataSource {
    case ToolfaceA
    static let allValues = [ToolfaceA]
    
    func getTitle() -> String {
        var result = ""
        
        switch self {
        case ToolfaceA: result = "Toolface A"
        default: result = ""
        }
        
        return result
    }
}

class Compass: Item {
    var sensorType: CompassSensorType
    var dataSource: CompassDataSource
    
    init(xPosition: Int, yPosition: Int, jsFileName: String, curveID: Int, sensorType: CompassSensorType, dataSource: CompassDataSource) {
        self.sensorType = sensorType
        self.dataSource = dataSource
        
        super.init(xPosition: xPosition, yPosition: yPosition, jsFileName: sensorType.getTitle() + ".js")
    }
}