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

class CurveTests: XCTestCase {
    
    var optionalSDISession: SDISession?
    var optionalUser: User?
    
    override func setUp() {
        super.setUp()
        
        /*
        self.optionalSDISession = UserSession(username: "capstone2015\\testuser", password: "StartUp!")
        self.optionalUser = User(session: optionalUserSession!)
        */
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        /*
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
        */
        super.tearDown()
    }
    
    func testGetCurvePointCollection() {
        println("--- Get Curve Point Collection API Test ---")
        /*
        if let session = self.optionalUserSession {
            if let user = self.optionalUser {
                var expectation: XCTestExpectation?
                expectation = self.expectationWithDescription("Login")
                println(" Logging In ...")
                
                session.login { (loggedIn) -> Void in
                    println(" Logged in.")
                    
                    if loggedIn {
                        var (wells, error) = Well.getWellsForUser(user)
                        
                        for well in wells {
                            println("Well: " + well.name)
                            
                            for wellbore in well.wellbores {
                                println("Wellbore: " + wellbore.name)
                                
                                var (curves, error) = wellbore.getCurves(user)
                                for curve in curves {
                                    println("Curve: " + curve.name)
                                    let (optionalCurvePointCollection, error) = curve.getCurvePointCollectionBetweenStartDate(
                                        NSDate(),
                                        andEndDate: NSDate())
                                    
                                    assert(error == nil, error!)
                                    
                                    if let curvePointCollection = optionalCurvePointCollection {
                                        assert(curve.id == curvePointCollection.curveID,
                                            "Curve IDs do not match between CurvePointCollection (\(curvePointCollection.curveID)) and Curve (\(curve.id)).")
                                        assert(wellbore.id == curvePointCollection.wellboreID,
                                            "Wellbore IDs do not match between CurvePointCollection and Wellbore.")
                                        for curvePoint in curvePointCollection.curvePoints {
                                            println("Curve Point Value: \(curvePoint.value)")
                                        }
                                        
                                    } else {
                                        assert(false, "Could not get curve point collection.")
                                    }
                                
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
        */
    }
}
    