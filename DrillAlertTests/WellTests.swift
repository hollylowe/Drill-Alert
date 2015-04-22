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

class WellTests: XCTestCase {
    
    var optionalUserSession: UserSession?
    var optionalUser: User?
    
    override func setUp() {
        super.setUp()
        
        self.optionalUserSession = UserSession(username: "capstone2015\\testuser", password: "StartUp!")
        self.optionalUser = User(session: optionalUserSession!)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testGetWellsForUser() {
        println("--- Get Wells API Test ---")
        
        if let session = self.optionalUserSession {
            if let user = self.optionalUser {
                var expectation: XCTestExpectation?
                expectation = self.expectationWithDescription("Login")
                println(" Logging In ...")
                
                session.login { (loggedIn) -> Void in
                    println(" Logged in.")
                    
                    if loggedIn {
                        var (wells, error) = Well.getWellsForUser(user)
                        
                        println(" Wells Recieved:")
                        for well in wells {
                            println("  " + well.name)
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
    