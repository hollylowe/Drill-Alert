//
//  WellDetailTabBarController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/4/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class WellboreDetailTabBarController: UITabBarController {
    // Implicit - set by the previous view controller
    var currentWellbore: Wellbore!
    
    override func viewDidLoad() {
        self.title = currentWellbore.name
        
        super.viewDidLoad()
    }
}