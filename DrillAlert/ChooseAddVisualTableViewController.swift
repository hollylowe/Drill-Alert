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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selected = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch selected{
            case 0:
                var vc = storyboard.instantiateViewControllerWithIdentifier("NewPlotTableViewController") as NewPlotTableViewController
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                var vc = storyboard.instantiateViewControllerWithIdentifier("NewCanvasTableViewController") as NewCanvasTableViewController
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                println("something went wrong")
        }
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var vc = storyboard.instantiateViewControllerWithIdentifier("EditViewTableViewController") as EditViewTableViewController
//        vc.wellboreDetailViewController = self.wellboreDetailViewController
//        vc.selectedView = view
//        self.navigationController?.pushViewController(vc, animated: true)

    }
}
