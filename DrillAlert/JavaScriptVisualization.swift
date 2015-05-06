//
//  JavaScriptVisualization.swift
//  DrillAlert
//
//  Created by Lucas David on 5/6/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

protocol JavaScriptVisualization {
    func getInitializerJavaScriptString() -> String!
    func getTickJavaScriptStringWithDataPoint(dataPoint: NSNumber) -> String!
}