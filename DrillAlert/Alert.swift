//
//  Alert.swift
//  DrillAlert
//
//  Created by Lucas David on 11/29/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

enum Priority : String {
    case High = "High", Low = "Low"
}

class Alert {
    var value: Int
    var alertWhenRisesToValue: Bool
    var priority: Priority
    
    init(value: Int, alertWhenRisesToValue: Bool, priority: Priority) {
        self.value = value
        self.alertWhenRisesToValue = alertWhenRisesToValue
        self.priority = priority
    }
}