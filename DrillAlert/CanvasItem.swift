//
//  CanvasItem.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class CanvasItem: Visualization {
    var name: String
    var type: CanvasItemType
    var dataSource: CanvasItemDataSource
    
    init(xPosition: Int, yPosition: Int, curveID: Int, type: CanvasItemType, dataSource: CanvasItemDataSource, name: String) {
        self.type = type
        self.name = name
        self.dataSource = dataSource
        super.init(xPosition: xPosition, yPosition: yPosition, jsFileName: type.getTitle() + ".js")
    }
    
}

