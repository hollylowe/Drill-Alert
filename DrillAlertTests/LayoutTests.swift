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

class LayoutTests: XCTestCase {
    
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
    
    func testGetLayoutJSONString() {
        println("Testing Get Layout JSON String")
        var panels = Array<Panel>()
        var visualizations = Array<Visualization>()
        let visualization = Visualization(id: 0, xPosition: 0, yPosition: 0, jsFileName: "Test.js", curveID: 0)
        let panel = Panel(id: 0, name: "Panel Test", position: 0, xDimension: 0, yDimension: 0, visualizations: visualizations, type: "None")
        visualizations.append(visualization)
        panels.append(panel)
        
        let layout = Layout(name: "Test Layout", panels: panels, userID: 0, wellboreID: 0)
        let expectedResult = "{ \"Panels\": [{\"Visualizations\": [],\"Pos\": 0,\"XDim\": 0,\"YDim\": 0,\"Name\": \"Panel Test\",\"Type\": \"None\"}], \"Name\": \"Test Layout\", \"WellboreId\": 0, \"UserId\": 0}"
        
        assert(expectedResult == layout.toJSONString(), "Invalid JSON")
        
        visualizations.append(visualization)
        let panel2 = Panel(id: 0, name: "Panel2", position: 0, xDimension: 0, yDimension: 0, visualizations: visualizations, type: "None")
        panels.append(panel2)
        
        let otherLayout = Layout(name: "Test Layout 2", panels: panels, userID: 0, wellboreID: 0)
        println(otherLayout.toJSONString())
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
    