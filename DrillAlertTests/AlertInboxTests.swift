//
//  AlertInboxTests.swift
//  DrillAlert
//
//  Created by Lucas David on 5/30/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import XCTest
import DrillAlert
class AlertInboxTests: XCTestCase {
    var optionalSDISession: SDISession?
    var optionalUser: User?
    
    override func setUp() {
        self.optionalUser = User(id: 0, guid: "0")
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAlertInbox() {
        let alertInbox = AlertInbox()
        if let user = self.optionalUser {
            // The fixture data for alert history items 
            // contains an alert of each type.
            user.shouldUseFixtureData = true
            
            if let error = alertInbox.reloadItemsForUser(user) {
                XCTAssert(false, "Alert Inbox reload failed, with error: \(error)")
            } else {
                for criticalItem in alertInbox.criticalItems {
                    assertPriorityForItem(criticalItem, expectedPriority: .Critical)
                    XCTAssert(!criticalItem.acknowledged, "Item should not be acknowledged.")
                }
                for warningItem in alertInbox.warningItems {
                    assertPriorityForItem(warningItem, expectedPriority: .Warning)
                    XCTAssert(!warningItem.acknowledged, "Item should not be acknowledged.")
                }
                for informationItem in alertInbox.informationItems {
                    assertPriorityForItem(informationItem, expectedPriority: .Information)
                    XCTAssert(!informationItem.acknowledged, "Item should not be acknowledged.")
                }
                
                for readCriticalItem in alertInbox.readCriticalItems {
                    assertPriorityForItem(readCriticalItem, expectedPriority: .Critical)
                    XCTAssert(readCriticalItem.acknowledged, "Item should be acknowledged.")
                }
                for readWarningItem in alertInbox.readWarningItems {
                    assertPriorityForItem(readWarningItem, expectedPriority: .Warning)
                    XCTAssert(readWarningItem.acknowledged, "Item should be acknowledged.")
                }
                for readInformationItem in alertInbox.readInformationItems {
                    assertPriorityForItem(readInformationItem, expectedPriority: .Information)
                    XCTAssert(readInformationItem.acknowledged, "Item should be acknowledged.")
                }
            }
        }
    }
    
    func assertPriorityForItem(item: AlertHistoryItem, expectedPriority priority: Priority) {
        if let priority = item.priority {
            XCTAssert(priority == priority, "Item did not have the correct priority.")
        } else {
            XCTAssert(false, "Item did not have a priority")
        }
    }
    
    
}