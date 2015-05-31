//
//  Dashboard.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class Dashboard {
    var id: Int?
    var name: String = ""
    var pages = Array<Page>()
    var userID: Int
    var wellboreID: String

    func swapPageAtIndex(index: Int, withPage newPage: Page) {
        let oldPage = self.pages[index]
        newPage.position = oldPage.position
        self.pages.removeAtIndex(index)
        self.pages.append(newPage)
    }
    
    func addPage(page: Page) {
        page.position = self.pages.count
        self.pages.append(page)
    }
    
    func updatePage(newPage: Page) {
        var index = 0
        
        for page in pages {
            if newPage.id != nil && page.id != nil {
                if newPage.id == page.id {
                    // Break once we get a match, 
                    // since we can now just remove the old
                    // page and insert the new one
                    break
                }
            }
            index++
        }
        
        self.pages.removeAtIndex(index)
        self.pages.append(newPage)
    }
    
    init(pages: Array<Page>, userID: Int, wellboreID: String) {
        self.pages = pages
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    init(userID: Int, wellboreID: String) {
        self.pages = Array<Page>()
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    init(id: Int, name: String, pages: Array<Page>, userID: Int, wellboreID: String) {
        self.id = id
        self.name = name
        self.pages = pages
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    init(name: String, pages: Array<Page>, userID: Int, wellboreID: String) {
        self.name = name
        self.pages = pages
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    func toJSONString() -> String {
        var JSONString = "{"
        
        // If this page has an ID, we are updating it.
        if let id = self.id {
            JSONString = JSONString + " \"Id\": \(id),"
        }
        
        JSONString = JSONString + " \"Name\": \"\(self.name)\","
        JSONString = JSONString + " \"Pages\": \(self.getPagesJSONString()),"
        
        // JSONString = JSONString + " \"WellboreId\": \"\(self.wellboreID)\""
        JSONString = JSONString + " \"WellboreId\": \"\(self.wellboreID)\","
        JSONString = JSONString + " \"UserId\": \(self.userID)"
        /*
        // With USER ID if needed
        JSONString = JSONString + " \"WellboreId\": \"\(self.wellboreID)\","
        JSONString = JSONString + " \"UserId\": \(self.userID)"
        */
        
        JSONString = JSONString + "}"
        
        return JSONString
    }
    
    func itemCurvesToJSONString() -> String {
        var JSONString = "["
        var totalItemCurvesCount = 0
        var totalItemCurves = [ItemCurve]()
        
        for page in self.pages {
            switch page.type {
            case .Plot:
                if let tracks = page.tracks {
                    for track in tracks {
                        for itemCurve in track.itemCurves {
                            totalItemCurves.append(itemCurve)
                        }
                    }
                }
            case .Canvas:
                if let canvasItems = page.canvasItems {
                    for canvasItem in canvasItems {
                        for itemCurve in canvasItem.itemCurves {
                            totalItemCurves.append(itemCurve)
                        }
                    }
                }
            default: break
            }
            
        }
        
        var itemCurveIndex = 0
        for itemCurve in totalItemCurves {
            JSONString = JSONString + itemCurve.toJSONString()
            if itemCurveIndex < totalItemCurves.count - 1 {
                JSONString = JSONString + ","
            }
            itemCurveIndex++
        }
        
        
        JSONString = JSONString + "]"
        
        return JSONString
    }
    
    func getPagesJSONString() -> String {
        var JSONString = "["
        var index = 0
        
        for page in self.pages {
            JSONString = JSONString + page.toJSONString()
            
            if index < self.pages.count - 1 {
                JSONString = JSONString + ","
            }
            
            index = index + 1
        }
        
        JSONString = JSONString + "]"
        
        return JSONString
    }
    
    // This is called after a dashboard has been saved.
    class func saveDashboardItemCurves(dashboard: Dashboard, forUser user: User, withCallback callback: ((error: String?) -> Void)) {
        if user.shouldUseFixtureData {
            println("Using fixture data, will not send.")
            println("The ItemCurve JSON:")
            let JSONString = dashboard.itemCurvesToJSONString()
            println(JSONString)
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                var URLString = "https://drillalert.azurewebsites.net/api/itemcurves"
                
                if let URL = NSURL(string: URLString) {
                    let JSONString = dashboard.itemCurvesToJSONString()
                    println("The ItemCurve JSON: " )
                    println(JSONString)
                    if let postData = JSONString.dataUsingEncoding(NSASCIIStringEncoding) {
                        let request = NSMutableURLRequest(URL: URL)
                        
                        let contentTypeValue = "application/x-www-form-urlencoded"
                        let contentTypeHeader = "Content-Type"
                        let acceptHeader = "Accept"
                        let acceptValue = "application/json"
                        let contentLengthValue = String(postData.length)
                        let contentLengthHeader = "Content-Length"
                        
                        request.HTTPBody = postData
                        request.setValue(
                            contentLengthValue,
                            forHTTPHeaderField: contentLengthHeader)
                        request.setValue(
                            contentTypeValue,
                            forHTTPHeaderField: contentTypeHeader)
                        request.setValue(
                            acceptValue,
                            forHTTPHeaderField: acceptHeader)
                        
                        if let session = user.session {
                            let task = session.session!.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    if let HTTPResponse = response as? NSHTTPURLResponse {
                                        let statusCode = HTTPResponse.statusCode
                                        if error != nil {
                                            println("Error when saving item curves : \(error.description)")
                                            // callback(error: "Unable to save Dashboard (\(statusCode)).")
                                        } else {
                                            // callback(error: nil)
                                            println("Successful post.")
                                        }
                                    }
                                })
                            })
                            task.resume()
                        } else {
                            println("Error: No session found for user.")
                        }
                        
                    }
                }
            })
        }
    }
    
    class func deleteDashboard(dashboardToDelete: Dashboard, forUser user: User, withCallback callback: ((error: String?) -> Void)) {
        
        if user.shouldUseFixtureData {
            println("Using fixture data, will not send delete request.")
            callback(error: nil)
        } else {
            if let id = dashboardToDelete.id {
                println("Deleting Dashboard #\(id)...")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    if let URL = NSURL(string: "https://drillalert.azurewebsites.net/api/dashboards/\(id)") {
                        let request = NSMutableURLRequest(URL: URL)
                        request.HTTPMethod = "DELETE"
                        
                        if let session = user.session {
                            let task = session.session!.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    if error == nil {
                                        callback(error: nil)
                                    } else {
                                        println(error!)
                                        callback(error: "Unable to delete dashboard.")
                                    }
                                    
                                })
                            })
                            
                            task.resume()
                        }
                        
                    }
                })
            } else {
                callback(error: "Unable to delete dashboard - had no ID to delete.")
            }
        }
        
    }
    
    class func saveDashboard(dashboardToSave: Dashboard,
        forUser user: User,
        andWellbore wellbore: Wellbore,
        withCallback callback: ((error: String?, dashboardID: Int?) -> Void)) {
        
            if user.shouldUseFixtureData {
                println("Using fixture data, will not send.")
                var jsonString = dashboardToSave.toJSONString()
                println("The JSON: " )
                println(jsonString)
                callback(error: nil, dashboardID: 0)
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    var URLString = "https://drillalert.azurewebsites.net/api/dashboards"
                    
                    if let id = dashboardToSave.id {
                        // Updating a dashboard
                        URLString = URLString + "/\(id)"
                    }
                    if let URL = NSURL(string: URLString) {
                        var jsonString = dashboardToSave.toJSONString()
                        println("The JSON: " )
                        println(jsonString)
                        if let postData = jsonString.dataUsingEncoding(NSASCIIStringEncoding) {
                            let postLength = String(postData.length)
                            let request = NSMutableURLRequest(URL: URL)
                            if dashboardToSave.id != nil {
                                request.HTTPMethod = "PUT"
                            } else {
                                request.HTTPMethod = "POST"
                            }
                            request.HTTPBody = postData
                            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                            request.setValue("application/x-www-form-urlencoded",
                                forHTTPHeaderField: "Content-Type")
                            request.setValue("application/json", forHTTPHeaderField: "Accept")
                            
                            if let session = user.session {
                                let task = session.session!.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        if let HTTPResponse = response as? NSHTTPURLResponse {
                                            let statusCode = HTTPResponse.statusCode
                                            if error != nil {
                                                println("Error when saving dashboard: \(error.description)")
                                                callback(error: "Unable to save Dashboard (\(statusCode)).", dashboardID: nil)
                                            } else {
                                                // Dashboard.saveDashboardItemCurves(dashboardToSave, forUser: user, withCallback: callback)
                                                println("Dashboard successfully saved.")
                                                if let dashboardIDString = NSString(data: data, encoding: NSASCIIStringEncoding) {
                                                   
                                                        
                                                    callback(error: nil, dashboardID: dashboardIDString.integerValue)
                                                    
                                                }
                                                
                                            }
                                        }
                                    })
                                })
                                task.resume()
                            }
                            
                        }
                    }
                })
            }
        
    }
    
    class func dashboardFromJSONObject(JSONObject: JSON) -> Dashboard? {
        var dashboard: Dashboard?
        
        let APIDashboardIDKey = "Id"
        let APINameKey = "Name"
        let APIUserIDKey = "UserId"
        let APIWellboreIDKey = "WellboreId"
        let APIPagesKey = "Pages"
        
        if let id = JSONObject.getIntAtKey(APIDashboardIDKey) {
            if let name = JSONObject.getStringAtKey(APINameKey) {
                if let userID = JSONObject.getIntAtKey(APIUserIDKey) {
                    if let wellboreID = JSONObject.getStringAtKey(APIWellboreIDKey) {
                        if let pagesJSONArray = JSONObject.getJSONArrayAtKey(APIPagesKey) {
                            let pages = Page.getPagesFromJSONArray(pagesJSONArray)
                            dashboard = Dashboard(
                                id: id,
                                name: name,
                                pages: pages,
                                userID: userID,
                                wellboreID: wellboreID)
                        }
                    }
                }
            }
        }
        
        return dashboard
    }
    
    class func getAllDashboardFixtureDataForUser(user: User, andWellbore wellbore: Wellbore) -> Array<Dashboard> {
        var result = Array<Dashboard>()
        var testPages = Array<Page>()
        var testTracks = Array<Track>()
        let testTrack = Track(xPosition: 0, yPosition: 0, itemSettings: ItemSettings(stepSize: 0, startRange: 0, endRange: 0, divisionSize: 0, scaleType: 0))
        testTracks.append(testTrack)
        
        let testPage = Page(name: "My Plot", xDimension: 0, yDimension: 0, tracks: testTracks)
        let testDashboard = Dashboard(
            id: 0,
            name: "Test Dash",
            pages: testPages,
            userID: user.id,
            wellboreID: wellbore.id)
        let testDashboard1 = Dashboard(
            id: 1,
            name: "Test Dash1",
            pages: testPages,
            userID: user.id,
            wellboreID: wellbore.id)
        result.append(testDashboard)
        result.append(testDashboard1)

        return result
    }
    
    class func getDashboardsForUser(user: User, andWellbore wellbore: Wellbore) -> (Array<Dashboard>, String?) {
        var result = Array<Dashboard>()
        var errorMessage: String?
        
        /*
        
        TODO: Change Implementation of retrieving dashboards to the 
                api/dashboards/{wellboreID} endpoint. This endpoint 
                is returning null for ItemSettings as of 5/24/2015, however
                the api/dashboards endpoint returns the correct field.
        
        
        let url = "https://drillalert.azurewebsites.net/api/dashboards/\(wellbore.id)"
        let session = user.session
        let dashboardsJSONArray = session.getJSONArrayAtURL(url)
        
        errorMessage = dashboardsJSONArray.getErrorMessage()
        
        if errorMessage == nil {
            if let dashboardJSONs = dashboardsJSONArray.array {
                for dashboardJSONObject in dashboardJSONs {
                    if let dashboard = Dashboard.dashboardFromJSONObject(dashboardJSONObject) {
                        result.append(dashboard)
                    }
                }
            }
        }
        */
        if user.shouldUseFixtureData {
            result = Dashboard.getAllDashboardFixtureDataForUser(user, andWellbore: wellbore)
        } else {
            let url = "https://drillalert.azurewebsites.net/api/dashboards/"
            if let session = user.session {
                let dashboardsJSONArray = session.getJSONArrayAtURL(url)
                
                errorMessage = dashboardsJSONArray.getErrorMessage()
                
                if errorMessage == nil {
                    if let dashboardJSONs = dashboardsJSONArray.array {
                        for dashboardJSONObject in dashboardJSONs {
                            if let dashboard = Dashboard.dashboardFromJSONObject(dashboardJSONObject) {
                    
                                if dashboard.wellboreID == wellbore.id {
                                    result.append(dashboard)
                                }
                            } else {
                                errorMessage = "Error retrieving dashboards: unable to get JSON object."
                            }
                        }
                    } else {
                        errorMessage = "Error retrieving dashboards: No array."
                    }
                }
            } else {
                errorMessage = "Error retrieving dashboards: No SDI Session for user."
            }
        }
        
        
        
        return (result, errorMessage)
    }
    
    class func getDashboardWithID(id: Int, forUser user: User, andWellbore wellbore: Wellbore) -> Dashboard? {
        var result: Dashboard?
        if user.shouldUseFixtureData {
            let dashboards = Dashboard.getAllDashboardFixtureDataForUser(user, andWellbore: wellbore)
            for dashboard in dashboards {
                if let dashboardID = dashboard.id {
                    if dashboardID == id {
                        result = dashboard
                        break
                    }
                }
            }
        } else {
            let (dashboards, error) = Dashboard.getDashboardsForUser(user, andWellbore: wellbore)
            
            if error == nil {
                for dashboard in dashboards {
                    if let dashboardID = dashboard.id {
                   
                        if dashboardID == id {
                            result = dashboard
                            break
                        }
                    } else {
                        println("Dashboard had no ID.")
                    }
                    
                }
            } else {
                println(error!)
            }
            
        }
        
        return result
    }
    
    class func getAllDashboardsForUser(user: User) -> (Array<Dashboard>, String?) {
        var result = Array<Dashboard>()
        var errorMessage: String?
        
        if user.shouldUseFixtureData {
            result = Dashboard.getAllDashboardFixtureDataForUser(user, andWellbore: Wellbore(id: "0", name: "Test Wellbore", well: Well(id: "0", name: "Test Well", location: "Test Location")))
        } else {
            let url = "https://drillalert.azurewebsites.net/api/dashboards"
            if let session = user.session {
                let dashboardsJSONArray = session.getJSONArrayAtURL(url)
                
                errorMessage = dashboardsJSONArray.getErrorMessage()
                
                if errorMessage == nil {
                    if let dashboardJSONs = dashboardsJSONArray.array {
                        for dashboardJSONObject in dashboardJSONs {
                            if let dashboard = Dashboard.dashboardFromJSONObject(dashboardJSONObject) {
                                result.append(dashboard)
                            }
                        }
                    }
                }
            }
        }
        
        return (result, errorMessage)
    }
}