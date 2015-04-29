//
//  AddTrackTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/25/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit
/*
class AddTrackTableViewController: UITableViewController {
    
    
    class func storyboardIdentifier() -> String! {
        return "AddTrackTableViewController"
    }

    override func viewDidLoad() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "rightBarButtonItemTapped:")
        super.viewDidLoad()
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = indexPath.row
        indexPath.section
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (indexPath.section == 0 ){
            switch selected {
            case 1:
                var vc = storyboard.instantiateViewControllerWithIdentifier("ScaleTypeTableViewController") as! ScaleTypeTableViewController
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                println("something went wrong")
            }
        }
        else {
            var vc = storyboard.instantiateViewControllerWithIdentifier("AddCurveTableViewController") as! AddCurveTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
*/