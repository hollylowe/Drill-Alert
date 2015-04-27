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

class Plot: Visualization {
    var units: PlotUnits
    var independentVariableType: PlotIndependentVariableType
    var stepSize: Float
    var startRange: Float
    var endRange: Float
    var tracks = Array<PlotTrack>()
    
    init(xPosition: Int, yPosition: Int, curveID: Int, units: PlotUnits, independentVariableType: PlotIndependentVariableType, stepSize: Float, startRange: Float, endRange: Float, tracks: Array<PlotTrack>) {

        self.units = units
        self.independentVariableType = independentVariableType
        self.stepSize = stepSize
        self.startRange = startRange
        self.endRange = endRange
        self.tracks = tracks
        super.init(xPosition: xPosition, yPosition: yPosition, jsFileName: "Plot.js", curveID: curveID)
    }
}