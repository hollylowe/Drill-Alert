//
//  WellTests.swift
//  DrillAlert
//
//  Created by Lucas David on 4/12/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import UIKit
import XCTest
import DrillAlert

class WellboreTests: XCTestCase {
    
    
    var optionalUserSession: UserSession?
    var optionalUser: User?
    
    override func setUp() {
        super.setUp()
        
        self.optionalUserSession = UserSession(username: "capstone2015\\testuser", password: "StartUp!")
        self.optionalUser = User(session: optionalUserSession!)
        
    }
    
    override func tearDown() {
        var expectation: XCTestExpectation?
        expectation = self.expectationWithDescription("Logout")
        println(" Logging out ...")
        if let session = self.optionalUserSession {
            session.logout({ (loggedOut) -> Void in
                println(" Logged out.")
                expectation?.fulfill()
            })
        }
        self.waitForExpectationsWithTimeout(15.0, handler: nil)

        super.tearDown()
    }

    
    func testGetWellboresForUser() {
        println("--- Get Wellbores API Test ---")
        
        var expectation: XCTestExpectation?
        expectation = self.expectationWithDescription("Network Request")
        println(" Logging In ...")
        
        if let session = self.optionalUserSession {
            if let user = self.optionalUser {
                session.login { (loggedIn) -> Void in
                    println(" Logged in.")
                    
                    if loggedIn {
                        var (wells, error) = Well.getWellsForUser(user)
                        
                        if (wells.count > 0) {
                            var testWell: Well?
                            
                            for well in wells {
                                for wellbore in well.wellbores {
                                    var (curves, error) = wellbore.getCurves(user)
                                    
                                    assert(error == nil, error!)
                                }
                            }
                            
                        }
                        
                        assert(error == nil, "Error getting wells for testuser.")
                    } else {
                        assert(false, "Could not log test user in")
                    }
                    expectation?.fulfill()

                }
                self.waitForExpectationsWithTimeout(15.0, handler: nil)
            }
        }
        
        
    }
}
    