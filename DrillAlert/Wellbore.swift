//
//  Wellbore.swift
//  DrillAlert
//
//  Created by Lucas David on 11/8/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation
import UIKit


class Point {
    var x: Double
    var y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

class Wellbore {
    var id: Int
    var name: String!
    var well: Well!
    var data = Array<Point>()
    var titles: Array<String>!
    var res: AnyObject!
    
    init(id: Int, name: String, well: Well) {
        self.id = id
        self.name = name
        self.well = well
    }
    
    // TODO: reomve, deprecated
    init(well: Well, name: String) {
        self.name = name
        self.well = well
        self.titles = ["\"blue\"", "\"more blue\""]
        // self.updateData()
        self.id = 0
    }
    
    // Data is in the form of
    // [{x: 1, y: 5}, {x: 20, y: 20}]
    func getDataString() -> String! {
        var resultString = "["
        var index = 0
        
        for point in data {
            var newPointString = "{"
            newPointString = newPointString + "x: " + NSNumber(double: point.x).stringValue
            newPointString = newPointString + ", "
            newPointString = newPointString + "y: " + NSNumber(double: point.y).stringValue
            newPointString = newPointString + "}"
            
            resultString = resultString + newPointString
            // If we're not the last point
            if index + 1 < data.count {
                // Add a comma
                index = index + 1
                resultString = resultString + ", "
            } else {
                resultString = resultString + "]"
            }
        }
        
        return resultString
    }
    
    func getOnePoint() -> Point {
        let url = "http://drillalert.azurewebsites.net/api/WellboreData/1"
        var x: Double = 0
        var y: Double = 0
        var (urlResult, urlError) = APIHelper.getSynchronousJSONArray(url)
        for dictionary in urlResult {
            if let xValue: AnyObject = dictionary["X"] {
                x = (xValue as NSNumber).doubleValue
            }
            if let yValue: AnyObject = dictionary["Y"] {
                y = (yValue as NSNumber).doubleValue
            }
        }
        
        return Point(x: x, y: y)
    }
    
    func updateData() {
        let url = "http://drillalert.azurewebsites.net/api/WellboreData/5"
        var (urlResult, urlError) = APIHelper.getSynchronousJSONArray(url)
        for dictionary in urlResult {
            var x: Double = 0
            var y: Double = 0
            if let xValue: AnyObject = dictionary["X"] {
                x = (xValue as NSNumber).doubleValue
            }
            if let yValue: AnyObject = dictionary["Y"] {
                y = (yValue as NSNumber).doubleValue
            }
            
            self.data.append(Point(x: x, y: y))
        }
    }
    
    /// An API call to get all of the wellbores a user
    /// is subscribed to.
    class func getSubscribedWellboresForUserID(userID: String) -> Array<Wellbore> {
        var wellbores = Array<Wellbore>()
        
        
        
        // Using canned data
        wellbores.append(Wellbore(well: Well(id: 0, name: "Well One", location: "Houston"), name: "Wellbore 1"))
        wellbores.append(Wellbore(well: Well(id: 0, name: "Well One", location: "Houston"), name: "Wellbore 3"))
        
        return wellbores
    }
    
    /// An API call to get all of the wellbores a user has
    /// access to.
    class func getAllWellboresForUserID(userID: String) -> Array<Wellbore> {
        var wellbores = Array<Wellbore>()
        
        // Using canned data
        wellbores.append(Wellbore(well: Well(id: 0, name: "Well One", location: "Houston"), name: "Wellbore 1"))
        wellbores.append(Wellbore(well: Well(id: 0, name: "Well One", location: "Houston"), name: "Wellbore 3"))
        wellbores.append(Wellbore(well: Well(id: 0, name: "Well One", location: "Houston"), name: "Wellbore 4"))
        
        return wellbores
    }
    
    func getData() -> Array<Point> {
        return self.data
    }
    
    func getTitles() -> Array<String>{
        return self.titles
    }
}