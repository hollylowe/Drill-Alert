//
//  CanvasItem.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
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

class CanvasItem: Visualization {
    var type: CanvasItemType
    var dataSource: CanvasItemDataSource
    
    init(xPosition: Int, yPosition: Int, jsFileName: String, curveID: Int, type: CanvasItemType, dataSource: CanvasItemDataSource) {
        self.type = type
        self.dataSource = dataSource
        
        super.init(xPosition: xPosition, yPosition: yPosition, jsFileName: type.getTitle() + ".js", curveID: 0)
    }
}