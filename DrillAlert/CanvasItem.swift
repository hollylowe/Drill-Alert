//
//  CanvasItem.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class CanvasItem: Item {
    var name: String
    var type: CanvasItemType {
        didSet {
            self.jsFileName = self.type.getJSFileName()
        }
    }
    
    init(id: Int, xPosition: Int, yPosition: Int, type: CanvasItemType, name: String) {
        self.type = type
        self.name = name
        super.init(
            id: id,
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: type.getJSFileName())
    }
    
    init(xPosition: Int, yPosition: Int, type: CanvasItemType, name: String) {
        self.type = type
        self.name = name
        super.init(
            xPosition: xPosition,
            yPosition: yPosition,
            jsFileName: type.getJSFileName())
    }
    
}

