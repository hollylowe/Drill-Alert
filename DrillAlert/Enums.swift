//
//  Enums.swift
//  DrillAlert
//
//  Created by Lucas David on 5/6/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

enum CanvasItemType {
    case NumberReadout, Gauge
    static let allValues = [NumberReadout, Gauge]
    
    func getTitle() -> String {
        var result = ""
        
        switch self {
        case NumberReadout: result = "Number Readout"
        case Gauge: result = "Gauge"
        default: result = ""
        }
        
        return result
    }
}

enum CanvasItemDataSource {
    case Depth, Temperature, Distance
    static let allValues = [Depth, Temperature, Distance]
    
    func getTitle() -> String {
        var result = ""
        
        switch self {
        case Depth: result = "Depth"
        case Temperature: result = "Temperature"
        case Distance: result = "Distance"
        default: result = ""
        }
        
        return result
    }
}

enum PlotTrackScaleType {
    case Linear, Logarithmic
    static let allValues = [Linear, Logarithmic]
    
    func getTitle() -> String {
        var result = ""
        
        switch self {
        case Linear: result = "Linear"
        case Logarithmic: result = "Logarithmic"
        default: result = ""
        }
        
        return result
    }
}
