//
//  Well.swift
//  DrillAlert
//
//  Created by Lucas David on 11/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation


class Well {
    var id: String
    var name: String
    var location: String
    var wellbores = Array<Wellbore>()
    
    init(id: String, name: String, location: String) {
        self.id = id
        self.name = name
        self.location = location
    }

    class func wellFromJSONObject(JSONObject: JSON) -> Well? {
        var result: Well?
        
        // Keys for the Well
        let APINameKey = "Name"
        let APIWellIDKey = "Id"
        let APILocationKey = "Location"
        let APIWellboresKey = "WellBores"
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getStringAtKey(APIWellIDKey) {
            if let name = JSONObject.getStringAtKey(APINameKey) {
                if let location = JSONObject.getStringAtKey(APILocationKey) {
                    // If we've recieved those values successfully, we can create a Well at least
                    let well = Well(id: id, name: name, location: location)
                    
                    if let wellboreJSONArray = JSONObject.getJSONArrayAtKey(APIWellboresKey) {
                        well.setWellboresFromJSONArray(wellboreJSONArray)
                    }
                    
                    result = well
                }
            }
        }
        
        return result
    }
    
    func setWellboresFromJSONArray(wellboresJSONArray: JSONArray) {
        // Keys for the Wellbore
        let APIWellboreIDKey = "id"
        let APIWellboreNameKey = "name"
        
        // For every wellbore this well has
        if let wellboreJSONs = wellboresJSONArray.array {
            for wellboreJSON in wellboreJSONs {
                
                // Get its ID and Name
                if let wellboreID = wellboreJSON.getStringAtKey(APIWellboreIDKey) {
                    if let wellboreName = wellboreJSON.getStringAtKey(APIWellboreNameKey) {
                        
                        // Create the Wellbore and add it to the Well
                        let wellbore = Wellbore(id: wellboreID, name: wellboreName, well: self)
                        self.wellbores.append(wellbore)

                    }
                }
            }
        }
    }
    
    class func getWellsForUser(user: User) -> (Array<Well>, String?) {
        var result = Array<Well>()
        var errorMessage: String?
        
        let url = "https://drillalert.azurewebsites.net/api/wells"
        let session = user.session
        let wellsJSONArray = session.getJSONArrayAtURL(url)
        errorMessage = wellsJSONArray.getErrorMessage()
        
        if errorMessage == nil {
            if let wellJSONs = wellsJSONArray.array {
                for wellJSONObject in wellJSONs {
                    if let well = Well.wellFromJSONObject(wellJSONObject) {
                        result.append(well)
                    }
                }
            }
        } else {
            // TODO: delete this, only for when the connection doesn't work
            if result.count == 0 {
                let well = Well(id: "", name: "Test", location: "Here")
                well.wellbores.append(Wellbore(id: "0", name: "Test Wellbore", well: well))
                result.append(well)
            }
        }
        
        return (result, errorMessage)
    }

}