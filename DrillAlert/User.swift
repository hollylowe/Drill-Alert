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
            user = User(firstName: "John", lastName: "Smith", id: "00000000-0000-0000-0000-000000000000", isAdmin: true)
        } else if username == "user0" {
            user = User(firstName: "Jameson", lastName: "Locke", id: "00000000-0000-0000-0000-000000000000")
        } else if username == "user1" {
            user = User(firstName: "Jameson", lastName: "Locke", id: "00000000-0000-0000-0000-000000000001")
        }
        
        return user
    }
    
    func logout() {
        // TODO: Log out user of ADFS here
    }


}