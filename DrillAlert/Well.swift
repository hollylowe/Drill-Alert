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
    
    func addWellbore(newWellbore: Wellbore) {
        self.wellbores.append(newWellbore)
    }
    
    class func getSubscribedWellsForUserID(userID: String) -> Array<Well> {
        // Keys for the Well
        let APINameKey = "name"
        let APIWellIDKey = "wellId"
        let APILocationKey = "location"
        let APIWellboresKey = "wellBores"
        
        // Keys for the Wellbore
        let APIWellboreIDKey = "wellboreId"
        let APIWellboreNameKey = "name"
        
        var result = Array<Well>()
        
        let url = "http://drillalert.azurewebsites.net/api/permissions/\(userID)"
        
        for dictionary in APIHelper.getJSONArray(url) {
            var newWellID: Int?
            var newWellName: String?
            var newWellLocation: String?
            
            if let anyObjectWellID: AnyObject = dictionary[APIWellIDKey] {
                newWellID = anyObjectWellID as? Int
            }
            
            if let anyObjectWellName: AnyObject = dictionary[APINameKey] {
                newWellName = anyObjectWellName as? String
            }
            
            if let anyObjectWellLocation: AnyObject = dictionary[APILocationKey] {
                newWellLocation = anyObjectWellLocation as? String
            }
            
            if let id = newWellID {
                if let name = newWellName {
                    if let location = newWellLocation {
                        let well = Well(id: id, name: name, location: location)
                        let wellboreAnyObjectArray = dictionary[APIWellboresKey] as Array<AnyObject>
                        
                        // Now add the wellbores to the well
                        for wellboreAnyObject in wellboreAnyObjectArray {
                            let wellboreDictionary = wellboreAnyObject as Dictionary<String, AnyObject>
                            var newWellboreID: Int?
                            var newWellboreName: String?

                            if let anyObjectWellboreID: AnyObject = wellboreDictionary[APIWellboreIDKey] {
                                
                                newWellboreID = anyObjectWellboreID as? Int
                            }
                            
                            if let anyObjectWellboreName: AnyObject = wellboreDictionary[APIWellboreNameKey] {
                                newWellboreName = anyObjectWellboreName as? String
                            }
                            
                            if let wellboreID = newWellboreID {
                                if let wellboreName = newWellboreName {
                                    let wellbore = Wellbore(id: wellboreID, name: wellboreName, well: well)
                                    well.addWellbore(wellbore)
                                }
                            }
                        }
                        
                        result.append(well)
                    }
                }
            }
        }
        
        // TODO: delete this, only for when the connection doesn't work
        if result.count == 0 {
            let well = Well(id: 0, name: "Test", location: "Here")
            well.addWellbore(Wellbore(well: well, name: "test"))
            result.append(well)
        }
        
        return result
        
    }

    
    /// This is an API call to get all of the wells
    /// as an array from the server. Used in the Admin 
    /// view.
    /*
    class func getAllWells() -> Array<Well> {
        var wells = Array<Well>()
        
        // Using canned data
        wells.append(Well(name: "Well 1"))
        wells.append(Well(name: "Well 2"))
        wells.append(Well(name: "Well 3"))
        wells.append(Well(name: "Well 4"))
        wells.append(Well(name: "Well 5"))

        return wells
    }
    */
    
    /// Gets all of the users that have access to 
    /// this well.
    func getUsers() -> Array<User> {
        var users = Array<User>()
        
        // Using canned data
        users.append(User(firstName: "Lucas", lastName: "David", id: "123"))
        users.append(User(firstName: "Another", lastName: "User", id: "117"))
        
        return users
    }

}