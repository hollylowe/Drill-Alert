//
//  AddEditTrackNavigationController.swift
//  DrillAlert
//
//  Created by Lucas David on 5/12/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddEditTrackNavigationController: UINavigationController {
    class func entrySegueIdentifier() -> String {
        return "AddEditTrackNavigationController"
    }
    
    class func editTrackEntrySegueIdentifier() -> String {
        return "EditTrackTableViewController"
    }
}