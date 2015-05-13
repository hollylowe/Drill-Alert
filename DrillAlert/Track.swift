//
//  Track.swift
//  DrillAlert
//
//  Created by Lucas David on 5/11/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
class Track: Visualization {
    var name: String
    var scaleType: PlotTrackScaleType
    var curves: Array<Curve>
    var divisionSize: String
    
    init(xPosition: Int, yPosition: Int, name: String, divisionSize: String, curves: Array<Curve>, scaleType: PlotTrackScaleType) {
        self.name = name
        self.divisionSize = divisionSize
        self.curves = curves
        self.scaleType = scaleType
        
        super.init(
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: "Track.js")
        
        var newCurveIDs = Array<Int>()
        for curve in curves {
            newCurveIDs.append(curve.id)
        }
        
        super.curveIDs = newCurveIDs
    }
}