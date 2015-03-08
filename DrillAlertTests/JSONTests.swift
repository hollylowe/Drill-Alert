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


class JSONTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSON() {
        
        let testDictionary = [
            "testString": "string",
            "testInt": 1,
            "testFloat": 2.5,
            "testBool": true
        ]
        
        let testJSON = JSON(dictionary: testDictionary)
        
        
        XCTAssert(testJSON.getIntAtKey("testInt") == 1, "getIntAtKey Failure")
        XCTAssert(testJSON.getStringAtKey("testString") == "string", "getStringAtKey Failure")
        XCTAssert(testJSON.getFloatAtKey("testFloat") == 2.5, "getFloatAtKey Failure")
        XCTAssert(testJSON.getBoolAtKey("testBool") == true, "getBoolAtKey Failure")
        
        XCTAssert(testJSON.getIntAtKey("testString") == nil, "getIntAtKey Failure")
        XCTAssert(testJSON.getStringAtKey("testInt") == nil, "getStringAtKey Failure")
        
    }
}