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
    let plotUpdateTime = 2.0
    let gaugeJSFileName = "Gauge.js"
    var user: User! 
    var page: Page!
    var itemCurves: [ItemCurve]?
    var timer: NSTimer?
    var pageIndex: Int!
    var wellbore: Wellbore! 
    var javaScriptVisualizations = Array<JavaScriptVisualization>()
    var javaScriptPlot: JavaScriptPlot?
    
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
    
    func updatePlot() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            // TODO: Actually use all of the item curves and tracks
            // (JavaScript doesn't support more than one curve and track)
            if let curves = self.itemCurves {
                if curves.count > 0 {
                    let firstCurve = curves[0]
                    
                    let (optionalCurvePointCollection, error) = Curve.getCurvePointCollectionForUser(self.user, curveID: firstCurve.curveID, startIV: 300, andEndIV: 500)
                    if error == nil {
                        if let curvePointCollection = optionalCurvePointCollection {
                            // Add every curve point to the graph
                            let curvePoints = curvePointCollection.curvePoints
                            // TODO: Use real curve points
                            if curvePoints.count > 0 {
                                if let plot = self.javaScriptPlot {
                                    let updateString = plot.getTickJavaScriptStringWithCurvePoint(curvePoints[0])
                                    self.webView.stringByEvaluatingJavaScriptFromString(updateString)
                                }
                            }
                            
                        }
                    } else {
                        // TODO: Show error to user
                        println("Error Getting Curve Points: " + error!)
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.timer = NSTimer.scheduledTimerWithTimeInterval(
                    self.plotUpdateTime,
                    target: self,
                    selector: "updatePlot",
                    userInfo: nil,
                    repeats: false)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd 'at' h:mm a"
                let stringDate = dateFormatter.stringFromDate(NSDate())
                self.pageLastUpdatedLabel.text = "Updated \(stringDate)"
            })
        })
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let dataTimer = timer {
            dataTimer.invalidate()
            timer = nil
        }
        
        super.viewWillDisappear(animated)
    }
    
    func setupPageAsPlot() {
        let defaultWidth = 300
        let defaultHeight = 150
        var allCurves = Array<ItemCurve>()
        
        if let id = page.id {
            // TODO: Replace with real initial data
            var initialData = [10, 20, 30, 40, 50, 60, 70]
            if let tracks = self.page.tracks {
                for track in tracks {
                    if let id = track.id {
                        var itemCurves = ItemCurve.getItemCurvesForUser(self.user, andItemID: id)
                        if itemCurves.count > 0 {
                            let (opCurves, opError) = Curve.addCurvesToItemCurves(itemCurves, user: self.user, andWellbore: self.wellbore)
                            
                            if let error = opError {
                                println("Error loading curves for item curves: \(error)")
                            } else {
                                if let newItemCurves = opCurves {
                                    println("Recieved new item curves successfully.")
                                    for curve in newItemCurves {
                                        allCurves.append(curve)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
            self.itemCurves = allCurves
            self.javaScriptPlot = JavaScriptPlot(
                id: id,
                yMax: page.yDimension,
                xMax: page.xDimension,
                initialData: initialData,
                width: defaultWidth,
                height: defaultHeight,
                page: page)
            
            if let plot = self.javaScriptPlot {
                // Initialize the plot
                self.webView.stringByEvaluatingJavaScriptFromString(plot.getInitializerJavaScriptString())
            }
            
            // Start the timer for the live update of a Plot
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(
                self.plotUpdateTime,
                target: self,
                selector: "updatePlot",
                userInfo: nil,
                repeats: false)

            
            
        }
    }
    
    func setupPageAsCanvas() {
        let defaultWidth = 400
        let defaultHeight = 300
        if let id = page.id {
            /*
            for item in page.items {
                // For a canvas, visualizations can be either 
                // gauges or number readouts.
                switch item.jsFileName {
                default: break
                }
            }
            */
        }
    }
}

extension PageViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        switch page.type {
        case .Plot: self.setupPageAsPlot()
        case .Canvas: self.setupPageAsCanvas()
        default: println("Unknown page type, \(page.type.getTitle())")
        }

        //for visualization in self.page.visualizations {
                        /*
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
            */
       // }

    }
}