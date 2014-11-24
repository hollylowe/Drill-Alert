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
    let wellbore = Wellbore(name: "cool bore")
    
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
}

extension VisualViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        let data = wellbore.getData()
        let title = wellbore.getTitles()
        var dataStr: String! = String("showData([")
//        Iterate through wellbore data and add to string
        for (idx, val) in enumerate(data) {
            if idx < data.count - 1 {
                dataStr = dataStr + String(val) + ", "
            }
            else {
                dataStr = dataStr + String(val) + "], ["
            }
        }
//        Iterate through wellbore titles and add to string
        for (idx, val) in enumerate(title) {
            if idx < title.count - 1 {
                dataStr = dataStr + String(val) + ", "
            }
            else {
                dataStr = dataStr + String(val) + "])"
            }
        }
        println(dataStr)
        self.webView.stringByEvaluatingJavaScriptFromString(dataStr)
    }
}