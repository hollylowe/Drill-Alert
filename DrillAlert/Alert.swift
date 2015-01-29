//
//  Alert.swift
//  DrillAlert
//
//  Created by Lucas David on 11/29/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class Alert {
    var type: AlertType
    var value: Int
    var priority: AlertPriority
    var alertOnRise: Bool
    var isActive: Bool
    
    init(type: AlertType, value: Int, alertOnRise: Bool, priority: AlertPriority) {
        self.type = type
        self.value = value
        self.priority = priority
        self.alertOnRise = alertOnRise
        self.isActive = true
    }
    
    // TODO: Use real API call
    class func getAlertsForUser(user: User, andWellbore wellbore: Wellbore) -> Array<Alert> {
        var result = Array<Alert>()
        
        result.append(Alert(type: .Temperature, value: 20, alertOnRise: true, priority: .Warning))
        result.append(Alert(type: .Pressure, value: 30, alertOnRise: true, priority: .Critical))
        result.append(Alert(type: .Azimuth, value: 56, alertOnRise: false, priority: .Information))
        result.append(Alert(type: .Inclination, value: 11, alertOnRise: true, priority: .Information))

        return result
    }
    
    func getInformationText() -> String! {
        var result = "\(self.type.name)"
        
        if alertOnRise {
            result = result + " has risen to "
        } else {
            result = result + " has fallen to "
        }
        
        result = result + "\(self.value) \(self.type.units)"
        
        return result
    }
}