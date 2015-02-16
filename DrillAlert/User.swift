//
//  User.swift
//  DrillAlert
//
//  Created by Lucas David on 11/6/14.
//  Copyright (c) 2014 Drillionaires. All rights reserved.
//

import Foundation

class UserSession: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    var session: NSURLSession?
    var shouldLogIn = true
    var wentToCurvePoints = false
    
    override init() {
        super.init()

        // Set up the session
        var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func loginWithUsername(username: String, andPassword password: String) {
        
        var URLString = "https://drillalert.azurewebsites.net/api/curvepoints/0/0/0/0"
        // var desiredURLString = "https://drillalert.azurewebsites.net/api/curvepoints/0/0/0/0"
        
        // Attempt to reach our website, get back the ADFS site
        if let URL = NSURL(string: URLString) {
            if let currentSession = self.session {
                var task = currentSession.dataTaskWithURL(URL, completionHandler: loginAttemptResponse)
                task.resume()
                
            }
        }
        
    }
    
    func apiAttemptResponse(data: NSData!, response: NSURLResponse!, error: NSError!) {
        
        
    }
    
    func finalResponse(data: NSData!, response: NSURLResponse!, error: NSError!) {
        // println("FINALLLL: \(NSString(data: data, encoding: NSASCIIStringEncoding))")
        println()
        println("Final: " )
        println()
        println(NSString(data: data, encoding: NSUTF8StringEncoding))
        
        if let HTTPResponse = response as? NSHTTPURLResponse {
            for headerField in HTTPResponse.allHeaderFields {
                if let headerFieldString = headerField.0 as? String {
                    if let value = headerField.1 as? String {
                        println("\(headerFieldString) : \(value)")
                    }
                }
            }
        }
        
        
    }
    
    func loginAttemptResponse(data: NSData!, response: NSURLResponse!, error: NSError!) {
        
        // println("login called, response \(response.URL)")
        var optionalWResult: String?
        var optionalWCTX: String?
        var optionalWA: String?
        
        if let content = NSString(data: data, encoding: NSASCIIStringEncoding) {
            var error: NSError?
            var parser = HTMLParser(html: content, encoding: NSASCIIStringEncoding, error: &error)
            if error != nil {
                println(error)
            } else {
                var bodyNode = parser.html
                if let inputNodes = bodyNode?.findChildTags("input") {
                    for node in inputNodes {
                        if node.getAttributeNamed("name") == "wresult" {
                            optionalWResult = node.getAttributeNamed("value")
                        } else if node.getAttributeNamed("name") == "wctx" {
                            optionalWCTX = node.getAttributeNamed("value")
                        } else if node.getAttributeNamed("name") == "wa" {
                            optionalWA = node.getAttributeNamed("value")
                        }
                    }
                }
            }
        }
        
        if let wresult = optionalWResult {
            if let wctx = optionalWCTX {
                if let wa = optionalWA {
                    var desiredURLString = "https://drillalert.azurewebsites.net/"
                    if let desiredURL = NSURL(string: desiredURLString) {
                        var request = NSMutableURLRequest(URL: desiredURL)
                        
                        // Set it to post
                        var postData = "wa=\(wa)&wresult=\(wresult)&wctx=\(wctx)"
                        /*
                        if let encodedPostDataString = CFURLCreateStringByAddingPercentEscapes(nil, postData, nil, "!*'();:@&=+$,/?%#[]", CFStringEncoding()) {
                        */
                        if let encodedPostData = (postData as NSString).dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true) {
                            
                            let postLength = "\(encodedPostData.length)"
                            
                                // println("encoded: \(encodedPostDataString)")
                                request.HTTPMethod = "POST"
                                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                                request.HTTPBody = encodedPostData

                                /*
                                if let HTTPResponse = response as? NSHTTPURLResponse {
                                    for headerField in HTTPResponse.allHeaderFields {
                                        if let headerFieldString = headerField.0 as? String {
                                            if let value = headerField.1 as? String {
                                                println("- Setting \(headerFieldString) to \(value)")
                                                request.setValue(value, forHTTPHeaderField: headerFieldString)
                                            }
                                        }
                                    }
                                }
                                */
                                request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
                                // request.setValue("Accept-Encoding", forHTTPHeaderField: "gzip, deflate")
                                request.setValue("en-US,en;q=0.8", forHTTPHeaderField: "Accept-Language")
                                request.setValue("max-age=0", forHTTPHeaderField: "Cache-Control")
                               // request.setValue("Connection", forHTTPHeaderField: "keep-alive")
                                // request.setValue("Content-Length", forHTTPHeaderField: "6034")
                               //
                                // request.setValue("Host", forHTTPHeaderField: "drillalert.azurewebsites.net")
                                request.setValue("https://capstone2015federation.scientificdrilling.com", forHTTPHeaderField: "Origin")
                                request.setValue("https://capstone2015federation.scientificdrilling.com/adfs/ls/?wa=wsignin1.0&wtrealm=https%3a%2f%2fdrillalert.azurewebsites.net&wctx=rm%3d0%26id%3dpassive%26ru%3d%252f&wct=2015-02-15T02%3a35%3a57Z", forHTTPHeaderField: "Referer")
                            request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36", forHTTPHeaderField: "User-Agent")
                                if let currentSession = session {
                                    var task = currentSession.dataTaskWithRequest(request, completionHandler: finalResponse)
                                    task.resume()
                                }
                            
                        }
                    }
                }
            }
        }

        
        // We got back the ADFS site, now we need to POST the username and password
        /*
        var desiredURLString = "https://drillalert.azurewebsites.net/api/curvepoints/0/0/0/0"
        if let desiredURL = NSURL(string: desiredURLString) {
            var newRequest = NSMutableURLRequest(URL: desiredURL)
            if let HTTPResponse = response as? NSHTTPURLResponse {
                for headerField in HTTPResponse.allHeaderFields {
                    if let headerFieldString = headerField.0 as? String {
                        if let value = headerField.1 as? String {
                            println("setting \(headerFieldString) to \(value)")
                            newRequest.setValue(value, forHTTPHeaderField: headerFieldString)
                        }
                    }
                }
                
                
            }
            
        }
        */
       // println("response url: \(response.URL)")
        /*
        var testUsername = "CAPSTONE2015%5Ctestuser"
        var testPassword = "StartUp!"
        
        if let loginURL = response.URL {
            var postString = "UserName=\(testUsername)&Password=\(testPassword)&AuthMethod=FormsAuthentication"
            var request = NSMutableURLRequest(URL: loginURL)
            var session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let response = NSURLResponse()
            
            var loginDataTask = session.dataTaskWithRequest(request, completionHandler: apiAttemptResponse)
            
            println("starting login")
            loginDataTask.resume()
        }
        */
    }

    
    func URLSession(session: NSURLSession,
        task: NSURLSessionTask,
        willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest,
        completionHandler: (NSURLRequest!) -> Void) {
            
            println()
            println("*********** REDIRECT *************")
            println()
            println("\(request.URL)")
            println()
            
            if shouldLogIn {
                shouldLogIn = false
                // Now we need to login
                
                // Create a new request with the redirect URL
                var newRequest = NSMutableURLRequest(URL: request.URL)
                println()
                println("Login Attempt")
                println()
                
                // Set it to post
                newRequest.HTTPMethod = "POST"
                for headerField in response.allHeaderFields {
                    if let headerFieldString = headerField.0 as? String {
                        if let value = headerField.1 as? String {
                            println("- Setting \(headerFieldString) to \(value)")
                            newRequest.setValue(value, forHTTPHeaderField: headerFieldString)
                        }
                    }
                }
                
                // Set the username and password
                var testUsername = "CAPSTONE2015%5Ctestuser"
                var testPassword = "StartUp!"
                var postString = "UserName=\(testUsername)&Password=\(testPassword)&AuthMethod=FormsAuthentication"
                newRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                
                // Now send it again, logging the user in. We 
                // will return to this same method since it will
                // redirect the user to their logged in view.
                completionHandler(newRequest)
                
            } else {
                
                completionHandler(request)
            }
                /*
            else if !wentToCurvePoints {
                // Now that we are authenticated, go to curve points for test.
                wentToCurvePoints = true
                println("Going to curve points...")
                var desiredURLString = "https://drillalert.azurewebsites.net/api/curvepoints/0/0/0/0"
                if let desiredURL = NSURL(string: desiredURLString) {
                    var newRequest = NSMutableURLRequest(URL: desiredURL)
                    
                    for headerField in response.allHeaderFields {
                        if let headerFieldString = headerField.0 as? String {
                            if let value = headerField.1 as? String {
                                println("setting \(headerFieldString) to \(value)")
                                newRequest.setValue(value, forHTTPHeaderField: headerFieldString)
                            }
                        }
                    }
                    
                    // This will redirect to SDI for authentication once
                    // completionHandler(newRequest)
                    
                    if let currentSession = self.session {
                        var newTask = currentSession.dataTaskWithRequest(newRequest, completionHandler: apiAttemptResponse)
                        newTask.resume()
                    }
                }
            } else {
                // Finally, we are at the API 
                completionHandler(request)
            }
            */
            // completionHandler(request)
    }
}

class User {
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    var id: String
    var guid: String
    var isAdmin: Bool
    
    init(firstName: String, lastName: String, id: String, guid: String, isAdmin: Bool = false) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.isAdmin = isAdmin
        self.guid = guid
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
        var testUsername = "CAPSTONE2015%5Ctestuser"
        var testPassword = "StartUp!"
        var userSession = UserSession()
        userSession.loginWithUsername(testUsername, andPassword: testPassword)
        
        /*
        // TODO: Make this url encode by itself
        
        var URLString = "https://drillalert.azurewebsites.net/"
        var desiredURLString = "https://drillalert.azurewebsites.net/api/curvepoints/0/0/0/0"
        
        // Attempt to reach our website, get back the ADFS site
        if let URL = NSURL(string: URLString) {
            let task = NSURLSession.sharedSession().dataTaskWithURL(URL, completionHandler: loginAttemptResponse)
            task.resume()
        }
        */
        
        user = User(firstName: "John", lastName: "Smith", id: "1", guid: "00000000-0000-0000-0000-000000000000", isAdmin: true)


        return user
    }
    
    func logout() {
        // TODO: Log out user of ADFS here
    }


}