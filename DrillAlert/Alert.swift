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
    var title: String = "None"
    var information: String = "None"
    
    init(value: Int, alertWhenRisesToValue: Bool, priority: Priority) {
        self.value = value
        self.alertWhenRisesToValue = alertWhenRisesToValue
        self.priority = priority
    }
    
    // test init
    init(title: String, information: String) {
        self.title = title
        self.information = information
        self.value = 0
        self.alertWhenRisesToValue = false
        self.priority = Priority.High
    }
}