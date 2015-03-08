//
//  VisualViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/16/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class JavaScriptPlot {
    var id: Int
    var yMax: Int
    var xMax: Int
    var initialData = Array<Int>()
    var width: Int
    var height: Int
    
    init(id: Int, yMax: Int, xMax: Int, initialData: Array<Int>, width: Int, height: Int) {
        self.id = id
        self.yMax = yMax
        self.xMax = xMax
        self.initialData = initialData
        self.width = width
        self.height = height
    }
    
    private func getInitialDataString() -> String {
        var dataString = "["
        var dataCount = 0
        if self.initialData.count > 0 {
            for dataPoint in self.initialData {
                dataString = dataString + "\(dataPoint)"
                if dataCount != self.initialData.count - 1 {
                    dataString = dataString + ", "
                }
                dataCount = dataCount + 1
            }
        }
        
        
        dataString = dataString + "]"
        return dataString
    }
    
    func getInitializerJavaScriptString() -> String {
        var plotInitializer = "master.init("
        var config = "{id: \(self.id), yMax: \(self.yMax), xMax: \(self.xMax), width: \(self.width), height: \(self.height), data: \(self.getInitialDataString())}"
        
        plotInitializer = plotInitializer + config + ")"
        return plotInitializer
    }
    
    func getTickStringWithDataPoint(dataPoint: Float) -> String {
        let tickString = "master.tick(\(dataPoint), \(self.id))"
        return tickString
    }
    
}

class JavaScriptGauge {
    
    var id: Int // id is required and is the identifier of the plot. (Should be unique)
    var size: Int // size is the diameter of the whole gauge in px
    var clipWidth: Int // the width of the div containing the gauge in px
    var clipHeight: Int // the height of the div containing the gauge in px
    var ringWidth: Int // how thick(wide) the color spectrum part of the gauge in px
    var maxValue: Int // the maximum value the gauge can reach
    var transitionMs: Int // the time it takes to transition from one value to the next in milliseconds
    
    init(id: Int, size: Int, clipWidth: Int, clipHeight: Int, ringWidth: Int, maxValue: Int, transitionMs: Int) {
        self.id = id
        self.size = size
        self.clipWidth = clipWidth
        self.clipHeight = clipHeight
        self.ringWidth = ringWidth
        self.maxValue = maxValue
        self.transitionMs = transitionMs
    }
    
    func getInitializerJavaScriptString() -> String {
        var gaugeInitializer = "masterGauge.init("
        var config = "{id: \(self.id), size: \(self.size), clipWidth: \(self.clipWidth), clipHeight: \(self.clipHeight), ringWidth: \(self.ringWidth), maxValue: \(self.maxValue), transitionMs: \(self.transitionMs)}"
        gaugeInitializer = gaugeInitializer + ")"
        
        return gaugeInitializer
    }
    
    
}

class VisualViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var panelInformationLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var panel: Panel!
    var timer: NSTimer?
    var pageIndex: Int!
    var htmlFileName = "index"

    class func getStoryboardIdentifier() -> String {
        return "VisualViewController"
    }
    
    override func viewDidLoad() {
        self.panelInformationLabel.text = self.panel.name
        var plot = JavaScriptPlot(id: 1, yMax: 1, xMax: 10, initialData: [0, 1, 2, 3, 4], width: 300, height: 500)
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Once the view has loaded,
        // set up the web view.
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
        println("update graph..")
        var dataStr = String("master.tick(\(xVal), 0)")
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
        self.webView.stringByEvaluatingJavaScriptFromString("master.init({yMax : 1, xMax : 10, data : [1, 2, 3, 4, 5], width : 500, height : 300, id: 0})")

        // This is purely for the demo
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateGraphData", userInfo: nil, repeats: true)

    }
}