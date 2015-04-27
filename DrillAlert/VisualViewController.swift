//
//  VisualViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/16/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

protocol JavaScriptVisualization {
    func getInitializerJavaScriptString() -> String!
    func getTickJavaScriptStringWithDataPoint(dataPoint: NSNumber) -> String!
}

class JavaScriptPlot: JavaScriptVisualization {
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
    
    func getInitializerJavaScriptString() -> String! {
        var plotInitializer = "master.init("
        var config = "{id: \(self.id), yMax: \(self.yMax), xMax: \(self.xMax), width: \(self.width), height: \(self.height), data: \(self.getInitialDataString())}"
        
        plotInitializer = plotInitializer + config + ")"
        return plotInitializer
    }
    
    func getTickJavaScriptStringWithDataPoint(dataPoint: NSNumber) -> String! {
        let tickString = "master.tick(\(dataPoint.stringValue), \(self.id))"
        return tickString
    }
    
}

class JavaScriptGauge: JavaScriptVisualization {
    
    var id: Int // id is required and is the identifier of the plot. (Should be unique)
    var size: Int = 300 // size is the diameter of the whole gauge in px
    var clipWidth: Int = 300 // the width of the div containing the gauge in px
    var clipHeight: Int = 300 // the height of the div containing the gauge in px
    var ringWidth: Int = 60 // how thick(wide) the color spectrum part of the gauge in px
    var maxValue: Int = 10  // the maximum value the gauge can reach
    var transitionMs: Int = 4000 // the time it takes to transition from one value to the next in milliseconds
    
    init(id: Int, size: Int, clipWidth: Int, clipHeight: Int, ringWidth: Int, maxValue: Int, transitionMs: Int) {
        self.id = id
        self.size = size
        self.clipWidth = clipWidth
        self.clipHeight = clipHeight
        self.ringWidth = ringWidth
        self.maxValue = maxValue
        self.transitionMs = transitionMs
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func getInitializerJavaScriptString() -> String! {
        var gaugeInitializer = "masterGauge.init("
        let config = "{id: \(self.id), size: \(self.size), clipWidth: \(self.clipWidth), clipHeight: \(self.clipHeight), ringWidth: \(self.ringWidth), maxValue: \(self.maxValue), transitionMs: \(self.transitionMs)}"
        
        gaugeInitializer = gaugeInitializer + config + ")"
        
        return gaugeInitializer
    }
    
    func getTickJavaScriptStringWithDataPoint(dataPoint: NSNumber) -> String! {
        let tickString = "masterGauge.update(\(dataPoint.stringValue), \(self.id))"
        return tickString
    }
    
    
}

class VisualViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var panelInformationLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var panelLastUpdatedLabel: UILabel!
    
    var panel: Panel!
    var timer: NSTimer?
    var pageIndex: Int!
    var javaScriptVisualizations = Array<JavaScriptVisualization>()
    
    let htmlFileName = "index"

    class func getStoryboardIdentifier() -> String {
        return "VisualViewController"
    }
    
    override func viewDidLoad() {
        self.panelInformationLabel.text = self.panel.name
        self.panelLastUpdatedLabel.text = "Loading..."
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Once the view has loaded,
        // set up the web view.
        if let htmlPath = NSBundle.mainBundle().pathForResource(htmlFileName, ofType: "html") {
            var possibleContent = String(contentsOfFile:htmlPath, usedEncoding: nil, error: nil)
            
            if let content = possibleContent {
                self.webView.delegate = self
                self.webView.loadHTMLString(content, baseURL: NSURL.fileURLWithPath(htmlPath.stringByDeletingLastPathComponent))
            }
            
        }
    }
    
    func updateVisualizations() {
        var dataValue: Float = 2.0
        
        for javaScriptVisualization in javaScriptVisualizations {
            if javaScriptVisualization is JavaScriptPlot {
                let testCurve = Curve(id: 0, name: "test curve", tooltype: "test type", units: "test units", wellbore: Wellbore(id: 0, name: "Test Wellbore", well: Well(id: 0, name: "Test well", location: "test location")))
                
                let (optionalCurvePointCollection, error) = testCurve.getCurvePointCollectionBetweenStartDate(NSDate(), andEndDate: NSDate())
                if error == nil {
                    if let curvePointCollection = optionalCurvePointCollection {
                        let curvePoints = curvePointCollection.curvePoints
                        if curvePoints.count > 0 {
                            dataValue = curvePoints[0].value
                        }
                    }
                } else {
                    // TODO: Show error to user
                    println("Error Getting Curve Points: " + error!)
                }
                
            }
            
            let updateString = javaScriptVisualization.getTickJavaScriptStringWithDataPoint(dataValue)
            self.webView.stringByEvaluatingJavaScriptFromString(updateString)
            
        }
        
        self.panelLastUpdatedLabel.text = "Updated \(NSDate())"
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
        let plotJSFileName = "Test.js"
        let gaugeJSFileName = "Test2.js"
        let defaultWidth = 400
        let defaultHeight = 300
        
        
        var newJavaScriptVisualizations = Array<JavaScriptVisualization>()
        
        for visualization in self.panel.visualizations {
            // TODO: Remove, only for the demo
            if self.panel.shouldShowDemoPlot {
                if let id = visualization.id {
                    newJavaScriptVisualizations.append(JavaScriptPlot(
                        id: id,
                        yMax: 10,
                        xMax: 20,
                        initialData: Array<Int>(),
                        width: defaultWidth,
                        height: defaultHeight))
                }
                
            } else {
                switch visualization.jsFileName {
                case plotJSFileName:
                    if let id = visualization.id {

                    newJavaScriptVisualizations.append(JavaScriptPlot(
                        id: id,
                        yMax: 10,
                        xMax: 10,
                        initialData: Array<Int>(),
                        width: defaultWidth,
                        height: defaultHeight))
                    }
                case gaugeJSFileName:
                    if let id = visualization.id {
                        let newGauge = JavaScriptGauge(id: id)
                        newJavaScriptVisualizations.append(newGauge)
                    }
                default: break
                }
            }
            
            
        }
        
        self.javaScriptVisualizations = newJavaScriptVisualizations
        
        // Initialize all the visualizations
        for javaScriptVisualization in javaScriptVisualizations {
            self.webView.stringByEvaluatingJavaScriptFromString(javaScriptVisualization.getInitializerJavaScriptString())
        }
        

        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateVisualizations", userInfo: nil, repeats: true)

    }
}