//
//  JSONArray.swift
//  DrillAlert
//
//  Created by Lucas David on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

let SERVER_ERROR_CODE = 1
let APIErrorKey = "Message"

class JSONArray {
    var error: NSError?
    var array: Array<JSON>?
    
    init() {}
    
    init(string: String) {
        var result: AnyObject?
        var jsonError: NSError?
        var urlError: NSError?
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonError)
            if jsonError != nil {
                self.error = jsonError
            } else {
                if let json = result as? Array<AnyObject> {
                    
                    self.array = Array<JSON>()
                    
                    for index in 0...json.count - 1 {
                        let object: AnyObject = json[index]
                        let objectDictionary = object as! Dictionary<String, AnyObject>
                        self.array!.append(JSON(dictionary: objectDictionary))
                    }
                    
                } else {
                    
                    if let errorDictionary = result as? Dictionary<String, AnyObject> {
                        
                        if let message = errorDictionary[APIErrorKey] as? String {
                            if let domain = NSBundle.mainBundle().bundleIdentifier {
                                var dictionary = Dictionary<String, String>()
                                dictionary[APIErrorKey] = message
                                
                                self.error = NSError(domain: domain, code: SERVER_ERROR_CODE, userInfo: dictionary)
                            }
                        }
                    }
                }
            }
        }
    }

    init(objectArray: Array<AnyObject>) {
        self.error = nil
        self.array = Array<JSON>()
        for object in objectArray {
            let objectDictionary = object as! Dictionary<String, AnyObject>
            self.array!.append(JSON(dictionary: objectDictionary))
        }
    }
    
    
    init(url: String) {
        var result: AnyObject?
        var jsonError: NSError?
        var urlError: NSError?
        
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
                    self.error = jsonError
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
                        
                        self.array = Array<JSON>()
                        
                        var index = 0
                        while index < json.count {
                            let object: AnyObject = json[index]
                            let objectDictionary = object as! Dictionary<String, AnyObject>
                            self.array!.append(JSON(dictionary: objectDictionary))
                            index++
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
                                    
                                    self.error = NSError(domain: domain, code: SERVER_ERROR_CODE, userInfo: dictionary)
                                }
                            }
                        }
                        
                    }
                    
                }
            }
            
            if urlError != nil {
                self.error = urlError
            }
        }
    }
    
    func getErrorMessage() -> String? {
        var errorMessage: String?
        
        if self.error != nil {
            if error!.code == -1005 {
                errorMessage = "The network connection was lost."
            } else {
                if let domain = NSBundle.mainBundle().bundleIdentifier {
                    if error!.code == SERVER_ERROR_CODE {
                        if let userInfo = error!.userInfo {
                            errorMessage = userInfo[APIErrorKey] as? String
                        }
                    } else {
                        errorMessage = "Unknown Error: \(error!.code)"
                        println(error!)
                    }
                    
                }
            }
        }
        
        return errorMessage
    }
    
}
