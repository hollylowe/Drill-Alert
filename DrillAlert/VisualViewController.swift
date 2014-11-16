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
        self.webView.stringByEvaluatingJavaScriptFromString("showData([200, 350], ['Blue', 'More Blue'])")
    }
}