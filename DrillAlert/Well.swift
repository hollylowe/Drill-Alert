//
//  Well.swift
//  DrillAlert
//
//  Created by Lucas David on 11/3/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation


class Well {
    var id: Int
    var name: String
    var location: String
    var wellbores = Array<Wellbore>()
    
    init(id: Int, name: String, location: String) {
        self.id = id
        self.name = name
        self.location = location
    }

    class func wellFromJSONObject(JSONObject: JSON) -> Well? {
        var result: Well?
        
        // Keys for the Well
        let APINameKey = "name"
        let APIWellIDKey = "wellId"
        let APILocationKey = "location"
        let APIWellboresKey = "wellBores"
        
        // Get the values at the above keys from the JSON Object
        if let id = JSONObject.getIntAtKey(APIWellIDKey) {
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
                if let wellboreID = wellboreJSON.getIntAtKey(APIWellboreIDKey) {
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
        
        let url = "https://drillalert.azurewebsites.net/api/permissions/\(user.guid)"
        if let session = user.userSession {
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
                    let well = Well(id: 0, name: "Test", location: "Here")
                    well.wellbores.append(Wellbore(well: well, name: "test"))
                    result.append(well)
                }
            }
        }
        
        return (result, errorMessage)
    }

    
    
    /// Gets all of the users that have access to 
    /// this well.
    func getUsers() -> Array<User> {
        var users = Array<User>()
        
        // Using canned data
        users.append(User(firstName: "Lucas", lastName: "David", id: "123", guid: "00000000-0000-0000-0000-000000000000"))
        users.append(User(firstName: "Another", lastName: "User", id: "117", guid: "00000000-0000-0000-0000-000000000000"))
        
        return users
    }

}