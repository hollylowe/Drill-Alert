//
//  Curve.swift
//  DrillAlert
//
//  Created by Lucas David on 2/2/15.
//  Copyright (c) 2015 Drillionaires. All rights reserved.
//

import Foundation

//GET: /api/curves
//  Client:
//      drillalert.azurewebsites.net/api/curves/{wellbore_id}
//  Returns:
//      JSON:
//          [
//              {
//                  id: 15,
//                  name: "tool temp",
//                  tooltype: "drill head",
//                  units: "kelvin"
//              },
//          ...
//         ]

//GET: /api/curvepoints
//  Client:
//      drillalert.azurewebsites.net/api/curvepoints/{wellbore_id}/{curve_id}/{start_time}/{end_time}
//      wellbore_id: 0, curve_id: 0-2,  any start/end time is fine
//
//  Parameter Header:
//  {
//      curve_id: 69,
//		wellbore_id: 2,
//		start_time: timestamp
//      end_time: timestamp
//  }
//  Returns:
//      JSON:
//          [
//              {
//                  curve_id: 34,
//                  wellbore_id: 3,
//                  data [
//                      {
//                          value: 0,
//                          time: timestamp
//                      },
//                      ...
//                  ]
//              },
//              ...
//           ]

class CurvePoint {
    var value: Float
    var time: Int // TODO: Change to Date eventually
    
    init(value: Float, time: Int) {
        self.value = value
        self.time = time
    }
    
    init(value: Float, stringTime: String) {
        self.value = value
        if let newTime = stringTime.toInt() {
            self.time = newTime
        } else {
            self.time = 0
        }
        
    }
}

class Curve {
    var id: Int
    var name: String
    var tooltype: String
    var units: String
    var wellbore: Wellbore
    
    init(id: Int, name: String, tooltype: String, units: String, wellbore: Wellbore) {
        self.id = id
        self.name = name
        self.tooltype = tooltype
        self.units = units
        self.wellbore = wellbore
    }
    
    func getCurvePoints() -> Array<CurvePoint> {
        var result = Array<CurvePoint>()
        
        // TODO: Change this to real values
        let startTime = 0
        let endTime = 0
        
        var endpointURL = "http://drillalert.azurewebsites.net/api/curvepoints/\(self.wellbore.id)/\(self.id)/\(startTime)/\(endTime)"
        println(endpointURL)
        let resultJSONArray = JSONArray(url: endpointURL)
        
        if let resultJSONs = resultJSONArray.array {
            // There's probably only one...
            for resultJSON in resultJSONs {
                if let wellboreId = resultJSON.getIntAtKey("wellboreId") {
                    if let curveId = resultJSON.getIntAtKey("curveId") {
                        if let data = resultJSON.getJSONArrayAtKey("data") {
                            if let curvePointJSONs = data.array {
                                for curvePointJSON in curvePointJSONs {
                                    
                                    if let curvePointValue = curvePointJSON.getFloatAtKey("value") {
                                        if let curvePointTime = curvePointJSON.getStringAtKey("time") {
                                            result.append(CurvePoint(value: curvePointValue, stringTime: curvePointTime))
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
            }
        } else {
            if let error = resultJSONArray.error {
                println(error)
            }
        }
        
        return result
    }
}