//
//  VisualViewController.swift
//  DrillAlert
//
//  Created by Lucas David on 11/16/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var pageInformationLabel: UILabel!
    @IBOutlet weak var pageLastUpdatedLabel: UILabel!
    @IBOutlet weak var pageHeaderView: UIView!
    @IBOutlet weak var webView: UIWebView!
    let mainHTMLFileName = "index"
    let plotJSFileName = "Plot.js"
    let gaugeJSFileName = "Gauge.js"
    var page: Page!
    var timer: NSTimer?
    var pageIndex: Int!
    var javaScriptVisualizations = Array<JavaScriptVisualization>()
    
    class func getStoryboardIdentifier() -> String {
        return "PageViewController"
    }
    
    override func viewDidLoad() {
        self.pageInformationLabel.text = self.page.name
        self.pageLastUpdatedLabel.text = "Loading..."
        self.addBottomBorder()
        super.viewDidLoad()
    }
    
    func initialHTMLLoad() {
        if let htmlPath = NSBundle.mainBundle().pathForResource(self.mainHTMLFileName, ofType: "html") {
            if let content = String(contentsOfFile: htmlPath, usedEncoding: nil, error: nil) {
                self.webView.delegate = self
                self.webView.loadHTMLString(content, baseURL: NSURL.fileURLWithPath(htmlPath.stringByDeletingLastPathComponent))
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.initialHTMLLoad()
        super.viewDidAppear(animated)
    }
    
    private func addBottomBorder() {
        var bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0,
            self.pageHeaderView.frame.size.height,
            self.pageHeaderView.frame.size.width,
            1.0)
        bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).CGColor
        self.pageHeaderView.layer.addSublayer(bottomBorder)
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a" 
        let stringDate = dateFormatter.stringFromDate(NSDate())
        self.pageLastUpdatedLabel.text = "Updated \(stringDate)"
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let dataTimer = timer {
            dataTimer.invalidate()
            timer = nil
        }
        
        super.viewWillDisappear(animated)
    }
}

extension PageViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let defaultWidth = 400
        let defaultHeight = 300
        
        var newJavaScriptVisualizations = Array<JavaScriptVisualization>()
        
        if self.page.type == .Plot {
            // Convert the visualizations to their JavaScript counterpart
            for visualization in self.page.visualizations {
                //newJavaScriptVisualizations.append()
            }
        }
        
        // Start the timer 
        /*
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0,
            target: self,
            selector: "updateVisualizations",
            userInfo: nil,
            repeats: true)
        */
        
        /*
        for visualization in self.page.visualizations {
            // TODO: Remove, only for the demo
            println(visualization.jsFileName)
            if self.page.shouldShowDemoPlot {
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
                default:
                    if let id = visualization.id {
                        
                        newJavaScriptVisualizations.append(JavaScriptPlot(
                            id: id,
                            yMax: 10,
                            xMax: 10,
                            initialData: Array<Int>(),
                            width: defaultWidth,
                            height: defaultHeight))
                    }
                }
            }
        }
        
        self.javaScriptVisualizations = newJavaScriptVisualizations
        
        // Initialize all the visualizations
        for javaScriptVisualization in javaScriptVisualizations {
            self.webView.stringByEvaluatingJavaScriptFromString(javaScriptVisualization.getInitializerJavaScriptString())
        }
        

        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "updateVisualizations", userInfo: nil, repeats: true)
        */
    }
}