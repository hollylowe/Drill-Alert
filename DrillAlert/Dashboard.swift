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
    var name: String
    var pages = Array<Page>()
    var userID: Int
    var wellboreID: String

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
        
        JSONString = JSONString + " \"Pages\": \(self.getPagesJSONString()),"
        JSONString = JSONString + " \"Name\": \"\(self.name)\","
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
    
    class func saveDashboard(dashboardToSave: Dashboard, forUser user: User, andWellbore wellbore: Wellbore, withCallback callback: ((error: String?) -> Void)) {
        var URLString = "https://drillalert.azurewebsites.net/api/dashboards"
        
        if let id = dashboardToSave.id {
            // Updating a dashboard
            URLString = URLString + "/\(id)"
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
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
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("application/json", forHTTPHeaderField: "Accept")
                    
                    let task = user.session.session!.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if let HTTPResponse = response as? NSHTTPURLResponse {
                                let statusCode = HTTPResponse.statusCode
                                if error != nil {
                                    println("Error when saving dashboard: \(error.description)")
                                    callback(error: "Unable to save Dashboard (\(statusCode)).")
                                } else {
                                    callback(error: nil)
                                }
                            }
                        })
                    })
                    task.resume()
                }
            }
        })
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
        let url = "https://drillalert.azurewebsites.net/api/dashboards/"
        let session = user.session
        let dashboardsJSONArray = session.getJSONArrayAtURL(url)
        
        errorMessage = dashboardsJSONArray.getErrorMessage()
        
        if errorMessage == nil {
            if let dashboardJSONs = dashboardsJSONArray.array {
                for dashboardJSONObject in dashboardJSONs {
                    if let dashboard = Dashboard.dashboardFromJSONObject(dashboardJSONObject) {
                        if dashboard.wellboreID == wellbore.id {
                            result.append(dashboard)
                        }
                    }
                }
            }
        }
        
        return (result, errorMessage)
    }
    
    class func getAllDashboardsForUser(user: User) -> (Array<Dashboard>, String?) {
        var result = Array<Dashboard>()
        var errorMessage: String?
        let url = "https://drillalert.azurewebsites.net/api/dashboards"
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
        
        return (result, errorMessage)
    }
}