//
//  Plot.swift
//  DrillAlert
//
//  Created by Lucas David on 4/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

enum PlotIndependentVariableType {
    case Depth, Time
    static let allValues = [Depth, Time]
    
    func getTitle() -> String {
        var result = ""
        
        switch self {
        case .Depth:
            result = "Depth"
        case .Time:
            result = "Time"
        }
        
        return result
    }
}

enum PlotUnits {
    case Feet, Meters
    static let allValues = [Feet, Meters]
    
    func getTitle() -> String {
        var result = ""
        
        switch self {
        case .Feet:
            result = "Feet"
        case .Meters:
            result = "Meters"
        }
        
        return result
    }
}

class Plot: Page {
    
}