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
    
    class func postEnevelopeForUsername(username: String, andPassword password: String) {
        let toURL = "https://capstone2015federation.scientificdrilling.com/adfs/services/trust/2005/certificatemixed"
        
        if let url = NSURL(string: toURL) {
            var request = NSMutableURLRequest(URL: url)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            
            var err: NSError?
            request.HTTPBody = User.getSOAPEnvelopeForUsername(
                username,
                andPassword: password).dataUsingEncoding(NSUTF8StringEncoding)
            
            request.addValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")

            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                println("Response: \(response)")
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Body: \(strData)")
                
            })
            
            task.resume()
        }
        
    }
    
    class func getSOAPEnvelopeForUsername(username: String, andPassword password: String) -> String {
        // RST
        let companyURL = "https://capstone2015federation.scientificdrilling.com/"

        let wsTrustURL = "http://docs.oasis-open.org/ws-sx/ws-trust/200512"
        let appliesToURL = "http://schemas.xmlsoap.org/ws/2004/09/policy"
        let keyType = "http://docs.oasis-open.org/ws-sx/ws-trust/200512/Bearer"
        let requestType = "http://docs.oasis-open.org/ws-sx/ws-trust/200512/Issue"
        let tokenType = "urn:oasis:names:tc:SAML:2.0:assertion"
        
        // Enevelope
        let toURL = "https://capstone2015federation.scientificdrilling.com/adfs/services/trust/2005/certificatemixed"
        let actionURL = "http://docs.oasis-open.org/ws-sx/ws-trust/200512/RST/Issue"
        let usernameToken = "uuid-6a13a244-dac6-42c1-84c5-cbb345b0c4c4-1"
        
        var envelope =
            "<s:Envelope xmlns:s='http://www.w3.org/2003/05/soap-envelope'" +
                        "xmlns:a='http://www.w3.org/2005/08/addressing'" +
                        "xmlns:u='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd'" +
                "<s:Header>" +
                    "<a:Action s:mustUnderstand='1'>" + actionURL + "</a:Action>" +
                    "<a:To s:mustUnderstand='1'>" + toURL + "</a:To>" +
                    "<o:Security s:mustUnderstand='1' mlns:o='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'>" +
                    "<o:UsernameToken u:Id=" + usernameToken + ">" +
                        "<o:Username>" + username + "</o:Username>" +
                        "<o:Password Type='http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText'>" + password + "</o:Password>" +
                    "</o:UsernameToken>" +
                    "</o:Security>" +
                "</s:Header>" +
                "<s:Body>" +
                    "<trust:RequestSecurityToken xmlns:trust='" + wsTrustURL + "'>" +
                    "<wsp:AppliesTo xmlns:wsp='" + appliesToURL + "'>" +
                        "<a:EndpointReference>" +
                            "<a:Address>" + companyURL + "</a:Address>" +
                        "</a:EndpointReference>" +
                    "</wsp:AppliesTo>" +
                    "<trust:KeyType>" + keyType + "</trust:KeyType>" +
                    "<trust:RequestType>" + requestType + "</trust:RequestType>" +
                    "<trust:TokenType>" + tokenType + "</trust:TokenType>" +
                "</trust:RequestSecurityToken>" +
                "</s:Body>" +
            "</s:Envelope>"
        
        return envelope
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
        
        var testUsername = "CAPSTONE2015\testuser"
        var testPassword = "StartUp!"
        
        User.postEnevelopeForUsername(testUsername, andPassword: testPassword)
        // Enter real authentication here
        /*
        if username == "admin" {
            user = User(firstName: "John", lastName: "Smith", id: "00000000-0000-0000-0000-000000000000", isAdmin: true)
        } else if username == "user0" {
            user = User(firstName: "Jameson", lastName: "Locke", id: "00000000-0000-0000-0000-000000000000")
        } else if username == "user1" {
            user = User(firstName: "Jameson", lastName: "Locke", id: "00000000-0000-0000-0000-000000000001")
        } else if username == "" {
            user = User(firstName: "Jameson", lastName: "Locke", id: "00000000-0000-0000-0000-000000000000")
        }
        */
        
        user = User(firstName: "John", lastName: "Smith", id: "00000000-0000-0000-0000-000000000000", isAdmin: true)

        
        return user
    }
    
    func logout() {
        // TODO: Log out user of ADFS here
    }


}