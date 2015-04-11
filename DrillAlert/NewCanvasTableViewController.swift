//
//  NewCanvasTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/18/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class NewCanvasTableViewController: UITableViewController {
    
    
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    
    var visuals: [Visual]!
    
    override func viewDidLoad() {
        self.title = "New Canvas"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "rightBarButtonItemTapped:")
        
        
        //self.tableView.rowHeight = 65
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "NewCanvasTableViewController"
    }
    
    
    
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = indexPath.row
        indexPath.section
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (indexPath.section == 1 ){
            switch selected {
            case 0:
                var vc = storyboard.instantiateViewControllerWithIdentifier("NewNumberReadoutTableViewController") as! NewNumberReadoutTableViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                var vc = storyboard.instantiateViewControllerWithIdentifier("NewGaugeTableViewController") as! NewGaugeTableViewController
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                println("something went wrong")
            }
        }
    }
}
