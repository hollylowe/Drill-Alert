//
//  ParameterAlert.swift
//  DrillAlert
//
//  Created by Lucas David on 11/29/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class ParameterAlert {
    var parameter: Parameter
    var alerts: [Alert]
    
    init(parameter: Parameter) {
        self.parameter = parameter
        self.alerts = Array<Alert>()
    }
    
    init(parameter: Parameter, alerts: [Alert]) {
        self.parameter = parameter
        self.alerts = alerts
    }
    
    func addAlert(newAlert: Alert) {
        // TODO: Save real data to Core Data and Server
        self.alerts.append(newAlert)
    }
    
    class func getParameterAlertsForUser(user: User, andWellbore wellbore: Wellbore) -> Array<ParameterAlert> {
        var result = Array<ParameterAlert>()
        
        // TODO: Use real data from Core Data and Server for alerts
        result.append(ParameterAlert(parameter: Parameter(name: "Temperature"), alerts: [Alert(value: 100, alertWhenRisesToValue: true, priority: .High)]))
        
        return result
    }
}