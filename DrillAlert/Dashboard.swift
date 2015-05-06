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
    var wellboreID: Int

    init(id: Int, name: String, pages: Array<Page>, userID: Int, wellboreID: Int) {
        self.id = id
        self.name = name
        self.pages = pages
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    init(name: String, pages: Array<Page>, userID: Int, wellboreID: Int) {
        self.name = name
        self.pages = pages
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    func toJSONString() -> String {
        var JSONString = "{"

        if let id = self.id {
            JSONString = JSONString + " \"Id\": \(id),"
        }
        
        JSONString = JSONString + " \"Panels\": \(self.getPagesJSONString()),"
        JSONString = JSONString + " \"Name\": \"\(self.name)\","
        JSONString = JSONString + " \"WellboreId\": \(self.wellboreID),"
        JSONString = JSONString + " \"UserId\": \(self.userID)"

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
    
    class func dashboardFromJSONObject(JSONObject: JSON) -> Dashboard? {
        var dashboard: Dashboard?
        
        if let id = JSONObject.getIntAtKey("Id") {
            if let name = JSONObject.getStringAtKey("Name") {
                if let userID = JSONObject.getIntAtKey("UserId") {
                    if let wellboreID = JSONObject.getIntAtKey("WellboreId") {
                        if let pagesJSONArray = JSONObject.getJSONArrayAtKey("Panels") {
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
        let url = "https://drillalert.azurewebsites.net/api/views/\(wellbore.id)"
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