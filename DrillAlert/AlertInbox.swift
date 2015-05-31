//
//  AlertInbox.swift
//  DrillAlert
//
//  Created by Lucas David on 5/30/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class AlertInbox {
    var readCriticalItems = [AlertHistoryItem]()
    var readInformationItems = [AlertHistoryItem]()
    var readWarningItems = [AlertHistoryItem]()
    var warningItems = [AlertHistoryItem]()
    var criticalItems = [AlertHistoryItem]()
    var informationItems = [AlertHistoryItem]()
    
    func reloadItemsForUser(user: User) -> String? {
        var (alertHistoryItems, optionalError) = AlertHistoryItem.getAlertsHistoryForUser(user)
        
        if optionalError == nil {
            self.criticalItems.removeAll(keepCapacity: false)
            self.warningItems.removeAll(keepCapacity: false)
            self.informationItems.removeAll(keepCapacity: false)
            
            self.readInformationItems.removeAll(keepCapacity: false)
            self.readWarningItems.removeAll(keepCapacity: false)
            self.readCriticalItems.removeAll(keepCapacity: false)
            
            for alertHistoryItem in alertHistoryItems {
                if alertHistoryItem.acknowledged {
                    if let priority = alertHistoryItem.priority {
                        switch priority {
                        case .Critical: readCriticalItems.append(alertHistoryItem)
                        case .Warning: readWarningItems.append(alertHistoryItem)
                        case .Information: readInformationItems.append(alertHistoryItem)
                        default: break
                        }
                    }
                } else {
                    if let priority = alertHistoryItem.priority {
                        switch priority {
                        case .Critical: criticalItems.append(alertHistoryItem)
                        case .Warning: warningItems.append(alertHistoryItem)
                        case .Information: informationItems.append(alertHistoryItem)
                        default: break
                        }
                    }
                    
                }
            }
        }
        
        return optionalError
    }
}