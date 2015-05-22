//
//  LayoutTests.swift
//  DrillAlert
//
//  Created by Lucas David on 4/24/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import XCTest
import DrillAlert

class DashboardTests: XCTestCase {
    
    var optionalSDISession: SDISession?
    var optionalUser: User?
    
    override func setUp() {
        var expectation: XCTestExpectation?
        expectation = self.expectationWithDescription("Login")
        
        let session = SDISession(username: "capstone2015\\testuser", password: "StartUp!")
        session.login { (loggedIn) -> Void in
            if loggedIn {
                self.optionalSDISession = session
                self.optionalUser = User.getCurrentUser()
                expectation?.fulfill()
            }
        }
        self.waitForExpectationsWithTimeout(15.0, handler: nil)
        
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        var expectation: XCTestExpectation?
        expectation = self.expectationWithDescription("Logout")
        
        if let session = self.optionalSDISession {
            session.logout({ (loggedOut) -> Void in
                expectation?.fulfill()
            })
        }
        self.waitForExpectationsWithTimeout(15.0, handler: nil)
        
        super.tearDown()
    }
    
    func testSaveDashboard() {
        /*
        let testWellID = 1
        let testWellboreID = 1
        
        let testWellbore = Wellbore(
            id: testWellboreID,
            name: "Test Wellbore",
            well: Well(
                id: "0",
                name: "Test Well",
                location: "Test Location"))
        
        if let user = self.optionalUser {
            var pages = Array<Page>()
            var testPage = Page(
                name: "Test Page",
                position: 0,
                xDimension: 0,
                yDimension: 0,
                visualizations: Array<Visualization>())
            
            pages.append(testPage)
            
            let newDashboard = Dashboard(
                name: "Test Dashboard",
                pages: pages,
                userID: user.id,
                wellboreID: testWellboreID)
            
            var expectation: XCTestExpectation?
            expectation = self.expectationWithDescription("SaveDashboard")
            
            // Create the new dashboard on the backend, 
            // and verify there were no errors.
            Dashboard.createNewDashboard(newDashboard, forUser: user, andWellbore: testWellbore, withCallback: { (error) -> Void in
                assert(error == nil, error!)
                
                expectation?.fulfill()
            })
            
            // Since this is an asynchrounous method, we need to wait 
            // for the expectation to fulfill.
            self.waitForExpectationsWithTimeout(15.0, handler: nil)
        }
        */
    }
    
}
    