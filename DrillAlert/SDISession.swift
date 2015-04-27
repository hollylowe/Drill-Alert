//
//  UserSession.swift
//  DrillAlert
//
//  Created by Lucas David on 2/16/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation
import UIKit

class SDISession: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    var session: NSURLSession?
    
    var loginViewController: LoginViewController?
    var shouldLogIn = true
    var loggedIn = false
    
    // Only used for automated testing.
    var username: String?
    var password: String?
    
    
    // Only used for automated testing.
    init(username: String, password: String) {
        super.init()
        self.username = username
        self.password = password
        
        var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    override init() {
        super.init()
        
        // Set up the session.
        var sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }
    
    func sendDeviceToken(token: String) {
        let url = "https://drillalert.azurewebsites.net/api/permissions/ios/" + token.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        println(url)
        if let URL = NSURL(string: url) {
            var newRequest = NSMutableURLRequest(URL: URL)
            // var postString = token
            // newRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            // Set it to POST, since we need to send
            // the Username / Password to this new
            // URL
            // newRequest.HTTPMethod = "GET"
            
            if let session = self.session {
                println("Sending device token.")
                let task = session.dataTaskWithRequest(newRequest, completionHandler: { (data, response, error) -> Void in
                    println("Device token sent.")
                })
                task.resume()
            }
        }
    }
    
    func sendFakeNotificationRequest() {
        println("sending fake request")
        let url = "https://drillalert.azurewebsites.net/api/push/0"
        if let URL = NSURL(string: url) {
            var newRequest = NSMutableURLRequest(URL: URL)
            
            if let session = self.session {
                let task = session.dataTaskWithRequest(newRequest, completionHandler: { (data, response, error) -> Void in
                    if let content = NSString(data: data, encoding: NSASCIIStringEncoding) {
                        println("Data from request: ")
                        println(content)
                        println("Response from request:")
                        println(response)
                    }
                })
                task.resume()
            }
        }
    }
    
    func logout(callback: ((Bool) -> Void)) {
        let url = "https://drillalert.azurewebsites.net/api/logout"
        if let URL = NSURL(string: url) {
            let newRequest = NSMutableURLRequest(URL: URL)
            
            if let session = self.session {
                let task = session.dataTaskWithRequest(newRequest, completionHandler: { (data, response, error) -> Void in
                   
                })
                task.resume()
                let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                if let cookies = cookieStorage.cookies {
                    for cookie in cookies {
                        if let HTTPCookie = cookie as? NSHTTPCookie {
                            cookieStorage.deleteCookie(HTTPCookie)
                        }
                    }
                }
                
                callback(true)
            }
        }
    }
    
    func getIntAtURL(url: String) -> Int? {
        var jsonError: NSError?
        var urlError: NSError?
        var result: Int?
        
        // Create a URL object with the given URL
        if let url = NSURL(string: url) {
            let request: NSURLRequest = NSURLRequest(URL:url)
            var response: NSURLResponse?
            
            // Attempt to retrieve the data from the URL
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &urlError) {
                if let resultString = NSString(data: data, encoding: NSASCIIStringEncoding) {
                    result = resultString.integerValue
                }
            }
        }
        
        return result
    }
    
    func getJSONArrayAtURL(url: String) -> JSONArray {
        var result: AnyObject?
        var jsonError: NSError?
        var urlError: NSError?
        var resultJSONArray = JSONArray()
        
        // Create a URL object with the given URL
        if let url = NSURL(string: url) {
            let request: NSURLRequest = NSURLRequest(URL:url)
            var response: NSURLResponse?
            
            // Attempt to retrieve the data from the URL
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &urlError) {
                // Attempt to convert the recieved data into a JSON
                result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonError)
                
                // Only move forward if the JSON was successfully serialized
                if jsonError != nil {
                    resultJSONArray.error = jsonError
                } else {
                    // The JSON has been successfully serialized,
                    // which means it (should) be an Array of AnyObject,
                    // as long as the server didn't run into an error.
                    if let json = result as? Array<AnyObject> {
                        
                        // Instantiate this JSON's array object,
                        // and convert every AnyObject in the JSON
                        // array into what they truly are, which is
                        // a Dictionary<String, AnyObject>.
                        //
                        // For example,
                        // [ { "foo": "bar" } ] would be an Array<AnyObject> with
                        // only one item. That item is a Dictionary with one key, "foo",
                        // with an AnyObject value, "bar", which just happens to be a String.
                        
                        resultJSONArray.array = Array<JSON>()
                        
                        if (json.count - 1) >= 0 {
                            for index in 0...json.count - 1 {
                                let object: AnyObject = json[index]
                                let objectDictionary = object as! Dictionary<String, AnyObject>
                                resultJSONArray.array!.append(JSON(dictionary: objectDictionary))
                            }
                        }
                        
                        
                    } else {
                        // Server Error occured
                        
                        // Convert the result to a dictionary object
                        if let errorDictionary = result as? Dictionary<String, AnyObject> {
                            
                            // Get the "Message" from the server response JSON
                            if let message = errorDictionary[APIErrorKey] as? String {
                                
                                // Create an error by using the unique
                                // bundle identifier (to let our app use our own
                                // error codes)
                                if let domain = NSBundle.mainBundle().bundleIdentifier {
                                    var dictionary = Dictionary<String, String>()
                                    dictionary[APIErrorKey] = message
                                    
                                    resultJSONArray.error = NSError(domain: domain, code: SERVER_ERROR_CODE, userInfo: dictionary)
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            
            if urlError != nil {
                resultJSONArray.error = urlError
            }
        }

        return resultJSONArray
    }
    
    func getJSONAtURL(url: String) -> JSON {
        var result: AnyObject?
        var jsonError: NSError?
        var urlError: NSError?
        var resultJSON = JSON()
        
        // Create a URL object with the given URL
        if let url = NSURL(string: url) {
            let request: NSURLRequest = NSURLRequest(URL:url)
            var response: NSURLResponse?
            
            // Attempt to retrieve the data from the URL
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &urlError) {
                // Attempt to convert the recieved data into a JSON
                result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonError)
                
                // Only move forward if the JSON was successfully serialized
                if jsonError != nil {
                    resultJSON.error = jsonError
                } else {
                    // The JSON has been successfully serialized,
                    // which means it (should) be an Array of AnyObject,
                    // as long as the server didn't run into an error.
                    if let json = result {
                        let objectDictionary = json as! Dictionary<String, AnyObject>
                        resultJSON = JSON(dictionary: objectDictionary)
                        
                    } else {
                        // Server Error occured
                        
                        // Convert the result to a dictionary object
                        if let errorDictionary = result as? Dictionary<String, AnyObject> {
                            
                            // Get the "Message" from the server response JSON
                            if let message = errorDictionary[APIErrorKey] as? String {
                                
                                // Create an error by using the unique
                                // bundle identifier (to let our app use our own
                                // error codes)
                                if let domain = NSBundle.mainBundle().bundleIdentifier {
                                    var dictionary = Dictionary<String, String>()
                                    dictionary[APIErrorKey] = message
                                    
                                    resultJSON.error = NSError(domain: domain, code: SERVER_ERROR_CODE, userInfo: dictionary)
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            
            if urlError != nil {
                resultJSON.error = urlError
            }
        }
        
        return resultJSON
    }
    
    func login(callback: ((Bool) -> Void)) {
        // The URL we're attempting to reach
        var URLString = "https://drillalert.azurewebsites.net/"
        
        if let URL = NSURL(string: URLString) {
            if let currentSession = self.session {
                // This will attempt to reach the URL, but we
                // will get a redirect since the user is not
                // logged in yet.
                //
                // Since we're going to be redirected to the SDI
                // login page, we need to handle that in the
                // willPerformHTTPRedirection method below.
                //
                // After we are redirected to the login page and
                // login, once that is complete, the loginAttemptResponse
                // method will be called.
                var task = currentSession.dataTaskWithURL(URL, completionHandler: { (data, response, error) -> Void in
                    // These are the three variables we need
                    // to get from SDI's server to send to
                    // our server via a POST in order to recieve
                    // the FedAuth and FedAuth1 cookies,
                    // which grants us access to our API.
                    var optionalWResult: String?
                    var optionalWCTX: String?
                    var optionalWA: String?
                    
                    // Now that we've logged the user in, the
                    // app has redirected us to the URL we were
                    // originally trying to reach.
                    //
                    // The DrillAlert server sees that we have logged in,
                    // but it still needs the FedAuth and FedAuth1 cookies
                    // before allowing access to our API. To get these,
                    // it redirects us to an SDI server page that is just
                    // a form.
                    //
                    // This form contains three variables, wresult, wctx, and
                    // wa, in inputs. These variables need to be sent
                    // via a POST to our Drill Alert server. Once they are
                    // sent, we are given the FedAuth and FedAuth1 cookies.
                    //
                    // Here, we're using an HTML parser to get those three
                    // variables out of that form.
                    if let content = NSString(data: data, encoding: NSASCIIStringEncoding) {
                        (optionalWResult, optionalWCTX, optionalWA) = self.extractWVariablesFromContent(content)
                    }
                    
                    // Verify we have each input before moving forward.
                    if let wresult = optionalWResult {
                        if let wctx = optionalWCTX {
                            if let wa = optionalWA {
                                self.setFedAuthCookiesWithWResult(wresult, andWCTX: wctx, andWA: wa, callback: callback)
                            }
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            callback(false)
                        })
                    }

                })
                task.resume()
                
            }
        }
    }
    
    func URLSession(session: NSURLSession,
        task: NSURLSessionTask,
        willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest,
        completionHandler: (NSURLRequest!) -> Void) {
            
            // Used for non-web based login
            
            
            // We know we should log in if
            // this is set. It should
            // probably be based off of the
            // page we get back though eventually.
            if shouldLogIn {
                shouldLogIn = false
                // Now we need to login
                
                // Create a new request with the redirect URL
                if let URL = request.URL {
                    var newRequest = NSMutableURLRequest(URL: URL)
                    
                    // Set it to POST, since we need to send
                    // the Username / Password to this new
                    // URL
                    newRequest.HTTPMethod = "POST"
                    
                    // Set the username and password
                    if let username = self.username {
                        if let password = self.password {
                            let encodedUsername = SDISession.encodeStringToPercentEscapedString(username)
                            var postString = "UserName=\(encodedUsername)&Password=\(password)&AuthMethod=FormsAuthentication"
                            
                            // Set the POST data to the HTTP body of the request
                            newRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                            
                            // Now send it again, logging the user in. We
                            // will return to this same method since it will
                            // redirect the user to their logged in view.
                            completionHandler(newRequest)
                        }
                    }
                }
                
                
            } else {
                // We were redirected again, but
                // we already logged in, so go through
                // with it.
                completionHandler(request)
            }
            
    }
    
    
    private func setFedAuthCookiesWithWResult(wresult: String, andWCTX wctx: String, andWA wa: String, callback: ((Bool) -> Void)) {
        // We need to encode each of these variables
        // into a URL safe format before sending them.
        var encodedWResult = SDISession.encodeStringToPercentEscapedString(wresult)
        var encodedWA = SDISession.encodeStringToPercentEscapedString(wa)
        var encodedWCTX = SDISession.encodeStringToPercentEscapedString(wctx)
        
        
        var fedAuthURLString = "https://drillalert.azurewebsites.net/"
        if let fedAuthURL = NSURL(string: fedAuthURLString) {
            var request = NSMutableURLRequest(URL: fedAuthURL)
            var encodedPostString = "wa=\(encodedWA)&wresult=\(encodedWResult)&wctx=\(encodedWCTX)"
            
            // Convert the POST data to NSData
            if let encodedPostData = encodedPostString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
                let postLength = "\(encodedPostData.length)"
                
                request.HTTPMethod = "POST"
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = encodedPostData
                
                if let currentSession = session {
                    var task = currentSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                        
                        
                        // Check the cookies we have now
                        // to verify we are logged in.
                        // If we have FedAuth and FedAuth1,
                        // we should be good.
                        var hasFedAuth = false
                        var hasFedAuth1 = false
                        
                        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
                            for cookie in cookies {
                                if let HTTPCookie = cookie as? NSHTTPCookie {
                                    if HTTPCookie.name == "FedAuth" {
                                        hasFedAuth = true
                                    } else if HTTPCookie.name == "FedAuth1" {
                                        hasFedAuth1 = true
                                    }
                                }
                            }
                        }
                        
                        self.loggedIn = hasFedAuth && hasFedAuth1
                        self.username = nil
                        self.password = nil
                        if self.loggedIn {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                callback(true)
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                callback(false)
                            })
                        }
                    })
                    task.resume()
                }
            }
        }
    }
    
    
    private func extractWVariablesFromContent(content: NSString) -> (String?, String?, String?) {
        var optionalWResult: String?
        var optionalWCTX: String?
        var optionalWA: String?
        var error: NSError?
        
        
        var parser = HTMLParser(html: content as String, encoding: NSASCIIStringEncoding, error: &error)

        if error != nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let loginViewController = self.loginViewController {
                    loginViewController.showInvalidLogInAlert()
                }
            })
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
        
        return (optionalWResult, optionalWCTX, optionalWA)
    }
    
    
    
    func getCurrentlyAuthenticatedUserID() -> Int? {
        let URLString = "https://drillalert.azurewebsites.net/api/users/"
        
        return self.getIntAtURL(URLString)
    }
    
    
    
    func finalResponse(data: NSData!, response: NSURLResponse!, error: NSError!) {
        // Check the cookies we have now
        // to verify we are logged in.
        // If we have FedAuth and FedAuth1,
        // we should be good.
        var hasFedAuth = false
        var hasFedAuth1 = false
        
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                if let HTTPCookie = cookie as? NSHTTPCookie {
                    if HTTPCookie.name == "FedAuth" {
                        hasFedAuth = true
                    } else if HTTPCookie.name == "FedAuth1" {
                        hasFedAuth1 = true
                    }
                }
            }
        }
        
        self.loggedIn = hasFedAuth && hasFedAuth1
        self.username = nil
        self.password = nil
        if self.loggedIn {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let loginViewController = self.loginViewController {
                    /*
                    var user = User(firstName: "John", lastName: "Smith", id: "1", guid: "00000000-0000-0000-0000-000000000001", isAdmin: true)
                    user.userSession = self
                    
                    loginViewController.userLoggedIn(user)
                    */
                }
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let loginViewController = self.loginViewController {
                    loginViewController.showInvalidLogInAlert()
                }
            })
        }
    }
    
    
    class func encodeStringToPercentEscapedString(string: String) -> String {
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFStringRef, nil, "!*'();:@&=+$,/?%#[]" as CFStringRef, kCFStringEncodingASCII) as String
    }
    
    
}