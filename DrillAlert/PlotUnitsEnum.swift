//
//  PlotUnitsEnum.swift
//  DrillAlert
//
//  Created by Lucas David on 5/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

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