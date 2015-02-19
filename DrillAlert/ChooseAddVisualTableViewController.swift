//
//  ChooseAddVisualTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/18/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class ChooseAddVisualTableViewController: UITableViewController {
    
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var visuals: [Visual]!
    
    override func viewDidLoad() {
        self.title = "Create New"
        self.tableView.rowHeight = 65
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "ChooseAddVisualTableViewController"
    }
    
    
    func leftBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
