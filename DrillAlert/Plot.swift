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
    var units: PlotUnits
    var independentVariableType: PlotIndependentVariableType
    var stepSize: Float
    var startRange: Float
    var endRange: Float
    var tracks = Array<Track>()
    
    init(name: String, position: Int, xDimension: Int, yDimension: Int, curveID: Int, units: PlotUnits, independentVariableType: PlotIndependentVariableType, stepSize: String, startRange: String, endRange: String, tracks: Array<Track>) {
        
        self.units = units
        self.independentVariableType = independentVariableType
        self.stepSize = 0
        self.startRange = 0
        self.endRange = 0
        // self.stepSize = stepSize
        // self.startRange = startRange
        // self.endRange = endRange
        
        self.tracks = tracks
        super.init(name: name, position: position, xDimension: xDimension, yDimension: yDimension, items: self.tracks)
        self.type = .Plot

    }
}

/*
class Plot: Visualization {
    var units: PlotUnits
    var independentVariableType: PlotIndependentVariableType
    var stepSize: Float
    var startRange: Float
    var endRange: Float
    var tracks = Array<Track>()
    
    init(xPosition: Int, yPosition: Int, curveID: Int, units: PlotUnits, independentVariableType: PlotIndependentVariableType, stepSize: Float, startRange: Float, endRange: Float, tracks: Array<Track>) {

        self.units = units
        self.independentVariableType = independentVariableType
        self.stepSize = stepSize
        self.startRange = startRange
        self.endRange = endRange
        self.tracks = tracks
        super.init(xPosition: xPosition, yPosition: yPosition, jsFileName: "Plot.js")
    }
}
*/