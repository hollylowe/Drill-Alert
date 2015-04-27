//
//  PlotTrack.swift
//  DrillAlert
//
//  Created by Lucas David on 4/23/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class PlotTrack {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getTitle() -> String {
        return "Track"
    }
}