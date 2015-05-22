//
//  CanvasItemDataSourceEnum.swift
//  DrillAlert
//
//  Created by Lucas David on 5/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
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
