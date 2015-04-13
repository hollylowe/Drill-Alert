//
//  User.swift
//  DrillAlert
//
//  Created by Lucas David on 11/6/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class User {
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


}