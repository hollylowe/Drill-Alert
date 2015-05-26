//
//  PlotIVTEnum.swift
//  DrillAlert
//
//  Created by Lucas David on 5/25/15.
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