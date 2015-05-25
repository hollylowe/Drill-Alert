//
//  PageTypeEnum.swift
//  DrillAlert
//
//  Created by Lucas David on 5/22/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

enum PageType {
    case Plot, Canvas, Compass, None
    static let allValues = [Plot, Canvas, Compass, None]
    func getTitle() -> String {
        var result = ""
        switch self {
        case Plot:
            result = "Plot"
        case Canvas:
            result = "Canvas"
        case Compass:
            result = "Compass"
        case None:
            result = "None"
        default: result = ""
        }
        
        return result
    }
    
    func getInt() -> Int {
        var result = -1
        switch self {
        case Canvas:
            result = 0
        case Plot:
            result = 1
        case Compass:
            result = 2
        default: result = -1
        }
        
        return result
    }
    
    // https://drillalert.azurewebsites.net/Help/ResourceModel?modelName=PanelType
    static func pageTypeFromInt(pageTypeInt: Int) -> PageType? {
        var result: PageType?
        
        switch pageTypeInt {
        case 0:
            result = Canvas
        case 1:
            result = Plot
        case 2:
            result = Compass
        default: break
        }
        
        return result
    }
    
}