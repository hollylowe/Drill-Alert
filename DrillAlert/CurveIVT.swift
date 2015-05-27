//
//  CurveIVT.swift
//  DrillAlert
//
//  Created by Lucas David on 5/26/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
enum CurveIVT: Int {
    case TrueVerticalDepth = 0
    case Time = 1
    case Depth = 2
    case VerticalSection = 3
    case None = 9
    static let allValues = [TrueVerticalDepth, Time, Depth, VerticalSection]
    func toString() -> String {
        var result: String!
        
        switch self {
        case .TrueVerticalDepth: result = "True Vertical Depth"
        case .Time: result = "Time"
        case .Depth: result = "Depth"
        case .VerticalSection: result = "Vertical Section"
        case .None: result = "None"
        }
        
        return result
    }
    
    static func curveIVTFromInt(integer: Int) -> CurveIVT {
        var result: CurveIVT
        
        switch integer {
        case 0: result = .TrueVerticalDepth
        case 1: result = .Time
        case 2: result = .Depth
        case 3: result = .VerticalSection
        default: result = .None
        }
        
        return result
    }
}