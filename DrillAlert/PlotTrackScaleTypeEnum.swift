//
//  PlotTrackScaleTypeEnum.swift
//  DrillAlert
//
//  Created by Lucas David on 5/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
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