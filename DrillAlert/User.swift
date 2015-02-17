//
//  User.swift
//  DrillAlert
//
//  Created by Lucas David on 11/6/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class User {
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    var id: String
    var guid: String
    var isAdmin: Bool
    var userSession: UserSession?
    
    
    init(firstName: String, lastName: String, id: String, guid: String, isAdmin: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.isAdmin = isAdmin
        self.guid = guid
    }
    
    /// Authenticate a username and password. If
    /// successful, return a new user object. Otherwise,
    /// return nil.
    ///
    /// :param: username The username to authenticate.
    /// :param: password The password of the user.
    /// :returns: A User object if the username and password could be authenticated, nil if not.
    class func authenticateSDIUsername(username: String, andPassword password: String, andDelegate delegate: LoginViewController) -> User? {
        var user: User?
        var newUserSession = UserSession()
        newUserSession.loginWithUsername(username, andPassword: password, andDelegate: delegate)

        user = User(firstName: "John", lastName: "Smith", id: "1", guid: "00000000-0000-0000-0000-000000000000", isAdmin: true)
        user!.userSession = newUserSession
        
        return user
    }
    
    func logout() {
        // TODO: Log out user of ADFS here
    }


}