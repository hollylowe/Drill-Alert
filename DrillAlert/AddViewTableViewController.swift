//
//  AddViewTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class AddViewTableViewController: UITableViewController {
    override func viewDidLoad() {
        self.title = "New Layout"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "rightBarButtonItemTapped:")
        
        super.viewDidLoad()
    }
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
         self.navigationController!.popViewControllerAnimated(true)
            //popToViewController(viewControllers[viewControllers.count - 3], animated: true);
    }
    
    class func storyboardIdentifier() -> String! {
        return "AddViewTableViewController"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (indexPath.section == 1 ){
            switch selected{
                case 0:
                    var vc = storyboard.instantiateViewControllerWithIdentifier("NewPlotTableViewController") as NewPlotTableViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    var vc = storyboard.instantiateViewControllerWithIdentifier("NewCanvasTableViewController") as NewCanvasTableViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    var vc = storyboard.instantiateViewControllerWithIdentifier("NewCompassTableViewController") as NewCompassTableViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                default:
                    println("something went wrong")
            }
        }
    }
   
}