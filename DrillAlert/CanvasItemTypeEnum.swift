//
//  CanvasItemType.swift
//  DrillAlert
//
//  Created by Lucas David on 5/22/15.
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
    
    func getJSFileName() -> String {
        var result = ""
        
        switch self {
        case NumberReadout: result = "NumberReadout.js"
        case Gauge: result = "Gauge.js"
        default: result = ""
        }
        
        return result
    }
    static func canvasItemTypeFromJSFileName(JSFileName: String) -> CanvasItemType? {
        var result: CanvasItemType?
        
        switch JSFileName {
            case CanvasItemType.NumberReadout.getJSFileName(): result = CanvasItemType.NumberReadout
            case CanvasItemType.Gauge.getJSFileName(): result = CanvasItemType.Gauge
            default: break
        }
        
        return result
    }
}