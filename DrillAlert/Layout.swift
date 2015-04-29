//
//  Layout.swift
//  DrillAlert
//
//  Created by Lucas David on 4/21/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class Layout {
    var id: Int?
    var name: String
    var panels = Array<Panel>()
    var userID: Int
    var wellboreID: Int

    init(id: Int, name: String, panels: Array<Panel>, userID: Int, wellboreID: Int) {
        self.id = id
        self.name = name
        self.panels = panels
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    // For creating a new Layout
    init(name: String, panels: Array<Panel>, userID: Int, wellboreID: Int) {
        self.name = name
        self.panels = panels
        self.userID = userID
        self.wellboreID = wellboreID
    }
    
    func toJSONString() -> String {
        var JSONString = "{"

        if let id = self.id {
            JSONString = JSONString + " \"Id\": \(id),"
        }
        
        JSONString = JSONString + " \"Panels\": \(self.getPanelsJSONString()),"
        JSONString = JSONString + " \"Name\": \"\(self.name)\","
        JSONString = JSONString + " \"WellboreId\": \(self.wellboreID),"
        JSONString = JSONString + " \"UserId\": \(self.userID)"

        JSONString = JSONString + "}"
        
        return JSONString
    }
    
    func getPanelsJSONString() -> String {
        var JSONString = "["
        var index = 0
        
        for panel in self.panels {
            JSONString = JSONString + panel.toJSONString()
            
            if index < self.panels.count - 1{
                JSONString = JSONString + ","
            }
            
            index = index + 1
        }
        
        JSONString = JSONString + "]"
        
        return JSONString
    }
    
    class func layoutFromJSONObject(JSONObject: JSON) -> Layout? {
        var layout: Layout?
        
        if let id = JSONObject.getIntAtKey("Id") {
            if let name = JSONObject.getStringAtKey("Name") {
                if let userID = JSONObject.getIntAtKey("UserId") {
                    if let wellboreID = JSONObject.getIntAtKey("WellboreId") {
                        if let panelsJSONArray = JSONObject.getJSONArrayAtKey("Panels") {
                            let panels = Panel.getPanelsFromJSONArray(panelsJSONArray)
                            layout = Layout(id: id, name: name, panels: panels, userID: userID, wellboreID: wellboreID)
                        }
                    }
                }
            }
        }
        
        return layout
    }
    
    class func getLayoutsForUser(user: User, andWellbore wellbore: Wellbore) -> (Array<Layout>, String?) {
        var result = Array<Layout>()
        var errorMessage: String?
        
        let url = "https://drillalert.azurewebsites.net/api/views/\(wellbore.id)"
        println(url)
        let session = user.session
        let layoutsJSONArray = session.getJSONArrayAtURL(url)
        errorMessage = layoutsJSONArray.getErrorMessage()
        
        if errorMessage == nil {
            if let layoutJSONs = layoutsJSONArray.array {
                for layoutJSONObject in layoutJSONs {
                    if let layout = Layout.layoutFromJSONObject(layoutJSONObject) {
                        result.append(layout)
                    }
                }
            }
        }
        
        return (result, errorMessage)
    }
}