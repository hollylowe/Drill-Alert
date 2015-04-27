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
                    
                    dateFormatter.dateFormat = "yyyy-MM-ddThh:mm:ss.SSSSSSSxxx"
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
    
    func getJSONArrayAtKey(key: String) -> JSONArray? {
        var result: JSONArray?
        
        if let implicitDictionary = dictionary {
            if let objectArray = implicitDictionary[key] as? Array<AnyObject> {
                result = JSONArray(objectArray: objectArray)
            }
        }
        
        return result
    }
    
}
