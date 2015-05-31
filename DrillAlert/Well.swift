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
        let APIWellboreIDKey = "Id"
        let APIWellboreNameKey = "Name"
        
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
        
        if user.shouldUseFixtureData {
            let testWell = Well(id: "0", name: "Test Well", location: "Test Location")
            let testWellbore = Wellbore(id: "0", name: "Test Wellbore Name", well: testWell)
            let testWellbore2 = Wellbore(id: "1", name: "Test Wellbore Name1", well: testWell)
            let testWellbore3 = Wellbore(id: "2", name: "Test Wellbore Name2", well: testWell)
            let testWellbore4 = Wellbore(id: "3", name: "Test Wellbore Name3", well: testWell)

            testWell.wellbores.append(testWellbore)
            testWell.wellbores.append(testWellbore2)
            testWell.wellbores.append(testWellbore3)
            testWell.wellbores.append(testWellbore4)
            let testWell2 = Well(id: "1", name: "Test Well1", location: "Test Location2")
            let testWellbore5 = Wellbore(id: "4", name: "Test Wellbore Name4", well: testWell2)

            testWell2.wellbores.append(testWellbore5)

            result.append(testWell)
            result.append(testWell2)
        } else {
            let url = "https://drillalert.azurewebsites.net/api/wells"
            
            if let session = user.session {
                let wellsJSONArray = session.getJSONArrayAtURL(url)
                errorMessage = wellsJSONArray.getErrorMessage()
                
                if errorMessage == nil {
                    if let wellJSONs = wellsJSONArray.array {
                        for wellJSONObject in wellJSONs {
                            if let well = Well.wellFromJSONObject(wellJSONObject) {
                                result.append(well)
                            } else {
                                println("Warning: Could not create well from JSON object.")
                            }
                        }
                    } else {
                        println("Error: No well JSON array.")
                    }
                } else {
                    println("Error: \(errorMessage!)")
                }
            } else {
                println("Error: User had no SDI Session.")
            }
        }
       
        return (result, errorMessage)
    }

}