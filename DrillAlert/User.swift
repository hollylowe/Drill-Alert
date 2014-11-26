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
    var isAdmin: Bool
    
    init(firstName: String, lastName: String, id: String, isAdmin: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.isAdmin = isAdmin
    }
    
    /// Authenticate a username and password. If
    /// successful, return a new user object. Otherwise,
    /// return nil.
    /// 
    /// :param: username The username to authenticate. 
    /// :param: password The password of the user.
    /// :returns: A User object if the username and password could be authenticated, nil if not.
    class func authenticateSDIUsername(username: String, andPassword password: String) -> User? {
        var user: User?
        
        // Enter real authentication here
        if username == "admin" {
            user = User(firstName: "John", lastName: "Smith", id: "117", isAdmin: true)
        } else if username == "user" {
            user = User(firstName: "Jameson", lastName: "Locke", id: "343")
        }
        
        return user
    }
    
    class func authenticateFacebookUser(facebookUser: FBGraphUser!) -> User? {
        var user: User?
        let userID = facebookUser.objectID
        
        // Enter real authentication here
        if userID == "10152531648166693" {
            user = User(firstName: "Lucas", lastName: "David", id: userID, isAdmin: true)
        } 
        
        return user
    }
}