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
    
    @IBOutlet weak var webView: UIWebView!
    var pageIndex: Int!
    let wellbore = Wellbore(well: Well(name: "Well One"), name: "cool bore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if let htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html") {
            var possibleContent = String(contentsOfFile:htmlPath, usedEncoding: nil, error: nil)
            
            if let content = possibleContent {
                self.webView.loadHTMLString(content, baseURL: NSURL.fileURLWithPath(htmlPath.stringByDeletingLastPathComponent))
            }
        }
    }
    
    // This is purely for the demo
    func updateGraphData() {
        let xVal = wellbore.getOnePoint().x
        
        var dataStr = String("tick(\(xVal))")
        self.webView.stringByEvaluatingJavaScriptFromString(dataStr)
    }
}

extension VisualViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        // This is purely for the demo
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateGraphData", userInfo: nil, repeats: true)

    }
}