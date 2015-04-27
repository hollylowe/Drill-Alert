//
//  User.swift
//  DrillAlert
//
//  Created by Lucas David on 11/6/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var guid: String
    var email: String
    var session: SDISession
    var displayName: String
    
    func getWells() -> (Array<Well>, String?) {
        return Well.getWellsForUser(self)
    }
    
    // Creates a User object with the currently logged 
    // in user's information.
    class func getCurrentUser() -> User? {
        let session = SDISession()
        var user: User?
        
        if let userID = session.getCurrentlyAuthenticatedUserID() {
            let URLString = "https://drillalert.azurewebsites.net/api/users/\(userID)"
            let userJSON = session.getJSONAtURL(URLString)
            if let errorMessage = userJSON.getErrorMessage() {
                println(errorMessage)
            } else {
                user = User.userFromUserJSON(userJSON, andSession: session)
            }
        }
        
        return user
    }
    
    class func userFromUserJSON(userJSON: JSON, andSession session: SDISession) -> User? {
        var user: User?
        
        if let userID = userJSON.getIntAtKey("Id") {
            if let userGUID = userJSON.getStringAtKey("Guid") {
                if let displayName = userJSON.getStringAtKey("DisplayName") {
                    if let email = userJSON.getStringAtKey("Email") {
                        user = User(id: userID, guid: userGUID, email: email, displayName: displayName, session: session)
                    }
                }
            }
        }
        
        return user
    }
    
    init(id: Int, guid: String, email: String, displayName: String, session: SDISession) {
        self.id = id
        self.guid = guid
        self.email = email
        self.displayName = displayName
        self.session = session
    }
    
    func logout(callback: ((Bool) -> Void)) {
        self.session.logout(callback)
    }
    
    /*
    var firstName: String?
    var lastName: String?
    
    var id = "1"
    var guid: String?
    var isAdmin: Bool?
    var userSession: UserSession?
    
    init(session: UserSession) {
        self.userSession = session
    }
    
    init(firstName: String, lastName: String, id: String, guid: String, isAdmin: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.isAdmin = isAdmin
        self.guid = guid
    }
 
    func logout() {
        // TODO: Log out user of ADFS here
    }

    */
}

    
