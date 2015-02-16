//
//  VisualViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/16/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class VisualViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var panelInformationLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var pageIndex: Int!
    var htmlFileName = "index"
    var panel: Panel!
    var timer: NSTimer?
    
    let wellbore = Wellbore(well: Well(id: 0, name: "Well One", location: "Houston"), name: "cool bore")
    
    class func getStoryboardIdentifier() -> String {
        return "VisualViewController"
    }
    
    override func viewDidLoad() {
        self.panelInformationLabel.text = "Panel ID: \(panel.id)"
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if let htmlPath = NSBundle.mainBundle().pathForResource(htmlFileName, ofType: "html") {
            
            var possibleContent = String(contentsOfFile:htmlPath, usedEncoding: nil, error: nil)
            
            if let content = possibleContent {
                self.webView.loadHTMLString(content, baseURL: NSURL.fileURLWithPath(htmlPath.stringByDeletingLastPathComponent))
            }
            
        }
    }
    
    // This is purely for the demo
    func updateGraphData() {
        let xVal = 2
        
        var dataStr = String("graph.tick(\(xVal))")
        self.webView.stringByEvaluatingJavaScriptFromString(dataStr)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let dataTimer = timer {
            dataTimer.invalidate()
            timer = nil
        }
        
        super.viewWillDisappear(animated)
    }
}

extension VisualViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        self.webView.stringByEvaluatingJavaScriptFromString("graph.init({yMax : 1, xMax : 10, data : [1, 2, 3, 4, 5], width : 500, height : 300})")

        // This is purely for the demo
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateGraphData", userInfo: nil, repeats: true)

    }
}