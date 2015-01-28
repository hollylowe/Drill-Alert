//
//  APIHelper.swift
//  DrillAlert
//
//  Created by Lucas David on 1/24/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation


class APIHelper {

    class func getSynchronousJSONArray(urlToRequest: String) -> (Array<Dictionary<String, AnyObject>>, String?) {
        var result: AnyObject?
        var resultArray = Array<Dictionary<String, AnyObject>>()
        var jsonError: NSError?
        var urlError: NSError?
        var errorMessage: String?
        
        if let url = NSURL(string: urlToRequest) {
            let request: NSURLRequest = NSURLRequest(URL:url)
            var response: NSURLResponse?
            
            if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &urlError) {
                result = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonError)
                if jsonError != nil {
                    println("Error: \(jsonError)")
                }
            }
            
            if urlError != nil {
                println("Error: \(urlError)")
            }
        }
        
        if let json = result as? Array<AnyObject> {
            for index in 0...json.count - 1 {
                let object: AnyObject = json[index]
                let objectDictionary = object as Dictionary<String, AnyObject>
                resultArray.append(objectDictionary)
            }
        } else {
            // Error occured 
            let APIErrorKey = "Message"
            
            if let errorDictionary = result as? Dictionary<String, AnyObject> {
                errorMessage = errorDictionary[APIErrorKey] as? String
            }
        }
        
        if errorMessage == nil {
            if urlError != nil {
                errorMessage = "Unknown Error: \(urlError!.code)"
                
                if urlError!.code == -1005 {
                    errorMessage = "The network connection was lost."
                }
            }
        }
        
        return (resultArray, errorMessage)
    }
    
    
    
}
