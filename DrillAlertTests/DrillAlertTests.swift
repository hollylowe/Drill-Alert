//
//  DrillAlertTests.swift
//  DrillAlertTests
//
//  Created by Lucas David on 11/2/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import UIKit
import XCTest
import DrillAlert

class DrillAlertTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    */
    
    func testLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        let navigationLoginViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        
        XCTAssert(navigationLoginViewController.viewControllers.count > 0,
            "Initial navigation controller has no children.")
        
        if let loginViewController = navigationLoginViewController.viewControllers[0] as? LoginViewController {
            XCTAssert(true, "Login view controller is inital view.")
        } else {
            XCTAssert(false, "First child of initial view controller is not login view controller.")
        }

    }
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
