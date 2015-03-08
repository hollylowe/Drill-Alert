//
//  JSONArrayTests.swift
//  DrillAlert
//
//  Created by Lucas David on 3/6/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

//
//  JSONTests.swift
//  DrillAlert
//
//  Created by Lucas David on 3/6/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import UIKit
import XCTest
import DrillAlert


class JSONArrayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONArray() {
        
        let testString = "[{\"Id\":1,\"UserId\":3,\"CurveId\":1,\"Name\":\"TestAlert\",\"Rising\":false},{\"Id\":2,\"UserId\":3,\"CurveId\":1,\"Name\":\"Test3\",\"Rising\":true}]"
        
        let testJSONArray = JSONArray(string: testString)
    
        if let array = testJSONArray.array {
            
            if array.count > 0 {
                let json = array[0]
                XCTAssert(array.count == 2, "Wrong count for JSON")
                XCTAssert(json.getIntAtKey("Id") == 1, "Could not get int for JSON")
                XCTAssert(json.getStringAtKey("Name") == "TestAlert", "Could not get string for JSON")
                XCTAssert(json.getBoolAtKey("Rising") == false, "Could not get bool for JSON")

            } else {
                XCTAssert(false, "Converting string to JSON failed.")
            }
        } else {
            XCTAssert(false, "Converting string to JSON failed.")
        }
    }
    
    func testJSONArrayError() {
        let testString = "{\"Message\":\"An error occurred\"}"
        
        let testJSONArray = JSONArray(string: testString)
        
        if let error = testJSONArray.getErrorMessage() {
            XCTAssert(error == "An error occurred", "Wrong error message.")
        } else {
            XCTAssert(false, "Could not get error message.")
        }
    }
}