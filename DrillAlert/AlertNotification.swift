//
//  AlertNotification.swift
//  DrillAlert
//
//  Created by Lucas David on 2/18/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AlertHistoryItem {
    var message: String?
    var priority: Priority?
    var date: NSDate?
    var dateString: String?
    var alertID: Int?
    var acknowledged: Bool?
    
    init(message: String, priority: Priority, date: NSDate, alertID: Int, acknowledged: Bool) {
        self.message = message;
        self.priority = priority;
        self.date = date
        self.alertID = alertID
        self.acknowledged = acknowledged
    }
    
    init(message: String, priority: Priority, alertID: Int, acknowledged: Bool, dateString: String) {
        self.message = message;
        self.priority = priority;
        self.dateString = dateString
        self.alertID = alertID
        self.acknowledged = acknowledged
    }
    
    class func alertHistoryItemFromJSONObject(JSONObject: JSON) -> AlertHistoryItem? {
        var error: String?
        var result: AlertHistoryItem?
        let APIDateKey              = "NotificationDate"
        let APIMessageKey           = "Message"
        let APIPriorityKey          = "NotificationSeverity"
        let APIAcknowledgedKey      = "Acknowledged"
        let APITriggeringAlertKey   = "TriggeringAlert"
        
        if let message = JSONObject.getStringAtKey(APIMessageKey) {
            if let priorityInt = JSONObject.getIntAtKey(APIPriorityKey) {
                if let priority = Priority(rawValue: priorityInt) {
                    if let date = JSONObject.getDateAtKey(APIDateKey) {
                        if let alertID = JSONObject.getIntAtKey(APITriggeringAlertKey) {
                            if let acknowledged = JSONObject.getBoolAtKey(APIAcknowledgedKey) {
                                result = AlertHistoryItem(
                                    message: message,
                                    priority: priority,
                                    date: date,
                                    alertID: alertID,
                                    acknowledged: acknowledged)
                            } else {
                                error = "Error: Could not create Alert History Item - Nothing found for \(APIAcknowledgedKey) key."
                            }
                        } else {
                            error = "Error: Could not create Alert History Item - Nothing found for \(APITriggeringAlertKey) key."
                        }
                    } else {
                        if let dateString = JSONObject.getStringAtKey(APIDateKey) {
                            if let alertID = JSONObject.getIntAtKey(APITriggeringAlertKey) {
                                if let acknowledged = JSONObject.getBoolAtKey(APIAcknowledgedKey) {
                                    result = AlertHistoryItem(
                                        message: message,
                                        priority: priority,
                                        alertID: alertID,
                                        acknowledged: acknowledged,
                                        dateString: dateString)
                                } else {
                                    error = "Error: Could not create Alert History Item - Nothing found for \(APIAcknowledgedKey) key."
                                }
                            } else {
                                error = "Error: Could not create Alert History Item - Nothing found for \(APITriggeringAlertKey) key."
                            }

                        }
                        
                        error = "Warning: Could not create Alert History Item - Nothing found for \(APIDateKey) key."
                    }
                } else {
                    error = "Error: Could not create Alert History Item - Invalid priority integer."
                }
            } else {
                error = "Error: Could not create Alert History Item - Nothing found for \(APIPriorityKey) key."
            }
        } else {
            error = "Error: Could not create Alert History Item - No message found."
        }
        
        if (error != nil) {
            println(error)
        }
        
        return result
    }
    
    // Return an array on success, or an error on fail.
    class func getAlertsHistory() -> ([AlertHistoryItem], String?) {
        var result = Array<AlertHistoryItem>()
        var error: String?
        
        let url = "https://drillalert.azurewebsites.net/api/alertshistory/"
        let alertNotificationJSONArray = JSONArray(url: url)
        if let networkError = alertNotificationJSONArray.error {
            error = networkError.description
        } else {
            if let array = alertNotificationJSONArray.array {
                for JSONObject in array {
                    if let alertHistoryItem = AlertHistoryItem.alertHistoryItemFromJSONObject(JSONObject) {
                        result.append(alertHistoryItem)
                    }
                }
            }
        }
        
        return (result, error)
    }
    
    func getNotificationBody() -> String! {
        return self.message
    }
    
}