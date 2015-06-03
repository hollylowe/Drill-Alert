//
//  JSON.swift
//  DrillAlert
//
//  Created by Lucas David on 1/27/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

class JSON {
    var dictionary: Dictionary<String, AnyObject>?
    var error: NSError?
    
    init() {}
    
    init(dictionary: Dictionary<String, AnyObject>) {
        self.dictionary = dictionary
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
    
    func getDateAtKey(key: String) -> NSDate? {
        var result: NSDate?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                if let dateString = object as? String {
                    let dateFormatter = NSDateFormatter()
                    
                    dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ss.SSSSSSS+00:00"
                                             // 2015-05-27T09:40:01.6916041+00:00
                    result = dateFormatter.dateFromString(dateString)
                }
            }
        }
        
        return result
    }
    
    func getIntAtKey(key: String) -> Int? {
        var result: Int?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                result = object as? Int
            }
        }
        
        return result
    }
    
    func getDoubleAtKey(key: String) -> Double? {
        var result: Double?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                result = object as? Double
            }
        }
        
        return result
    }
    
    func getBoolAtKey(key: String) -> Bool? {
        var result: Bool?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                result = object as? Bool
            }
        }
        
        return result
    }
    
    func getFloatAtKey(key: String) -> Float? {
        var result: Float?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                result = object as? Float
            }
        }
        
        return result
    }
    
    func getStringAtKey(key: String) -> String? {
        var result: String?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                result = object as? String
            }
        }
        
        return result
    }
    
    func getIntArrayAtKey(key: String) -> Array<Int>? {
        var result: Array<Int>?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                // TODO: Implement
            }
        }
        
        return [1]
    }
    
    func getJSONArrayAtKey(key: String) -> JSONArray? {
        var result: JSONArray?
        
        if let implicitDictionary = dictionary {
            if let objectArray = implicitDictionary[key] as? Array<AnyObject> {
                result = JSONArray(objectArray: objectArray)
            }
        }
        
        return result
    }
    
    class func JSONFromURL(url: String) -> JSON? {
        var resultJSON: JSON?
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
                    if let dataString = NSString(data: data, encoding: NSASCIIStringEncoding) {
                        if dataString == "null" {
                            resultJSON = JSON(dictionary: Dictionary<String, AnyObject>())
                        }
                    }
                } else {
                    if let json = result as? Dictionary<String, AnyObject> {
                        resultJSON = JSON(dictionary: json)
                    } else {
                        // Server Error occured
                        
                        // Convert the result to a dictionary object
                        if let errorDictionary = result as? Dictionary<String, AnyObject> {
                            
                            // Get the "Message" from the server response JSON
                            if let message = errorDictionary[APIErrorKey] as? String {
                                println("Error creating JSON: \(message)")
                            }
                        }
                        
                    }
                    
                }
            }
            
            if urlError != nil {
                println("URL Error: \(urlError)")
            }
        }
        
        return resultJSON
    }
    
}
