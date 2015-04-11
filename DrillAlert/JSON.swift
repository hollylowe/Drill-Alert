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
    
    init(dictionary: Dictionary<String, AnyObject>) {
        self.dictionary = dictionary
    }
    
    func getDateAtKey(key: String) -> NSDate? {
        var result: NSDate?
        
        if let implicitDictionary = dictionary {
            if let object: AnyObject = implicitDictionary[key] {
                result = object as? NSDate
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
