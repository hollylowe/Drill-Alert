//
//  AddPlotTableViewController.swift
//  DrillAlert
//
//  Created by Holly Lowe on 2/18/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class NewPlotTableViewController: UITableViewController {
    
    @IBOutlet weak var StepSize: UITextField!
    @IBOutlet weak var StartRange: UITextField!
    @IBOutlet weak var EndRange: UITextField!
    
    // Implicit, set by the previous view controller
    var wellboreDetailViewController: WellboreDetailViewController!
    var visuals: [Visual]!
    
    override func viewDidLoad() {
        self.title = "New Plot"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "rightBarButtonItemTapped:")

        
        //self.tableView.rowHeight = 65
        super.viewDidLoad()
    }
    
    class func storyboardIdentifier() -> String! {
        return "NewPlotTableViewController"
    }
    
    
    
    
    func rightBarButtonItemTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        var vc = storyboard.instantiateViewControllerWithIdentifier("EditViewTableViewController") as EditViewTableViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = indexPath.row
        indexPath.section
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if (indexPath.section == 1 ){
            switch selected {
                case 0:
                    var vc = storyboard.instantiateViewControllerWithIdentifier("IVTTableViewController") as IVTTableViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    var vc = storyboard.instantiateViewControllerWithIdentifier("UnitsTableViewController") as UnitsTableViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                default:
                    println("something went wrong")
            }
        }
        else {
           var vc = storyboard.instantiateViewControllerWithIdentifier("AddTrackTableViewController") as AddTrackTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        var vc = storyboard.instantiateViewControllerWithIdentifier("EditViewTableViewController") as EditViewTableViewController
        //        vc.wellboreDetailViewController = self.wellboreDetailViewController
        //        vc.selectedView = view
        //        self.navigationController?.pushViewController(vc, animated: true)
        
    
}
