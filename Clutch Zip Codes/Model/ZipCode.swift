//
//  ZipCode.swift
//  Clutch Zip Codes
//
//  Created by Seth Mosgin on 10/15/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ZipCode {
    var zipcode : String = ""
    var distance : String = ""
    var city : String = ""
    var state : String = ""
}

enum ZipCodeParsingError: Error {
    case valueNotFoundForKey(String)
}

extension ZipCode {
    init(jsonObject: JSON) throws {
        guard let zipCode = jsonObject["zip_code"].string else { throw ZipCodeParsingError.valueNotFoundForKey("zip_code") }
        guard let distance = jsonObject["distance"].double else { throw ZipCodeParsingError.valueNotFoundForKey("distance") }
        guard let city = jsonObject["city"].string else { throw ZipCodeParsingError.valueNotFoundForKey("city") }
        guard let state = jsonObject["state"].string else { throw ZipCodeParsingError.valueNotFoundForKey("state") }
        
        self.zipcode = zipCode
        self.distance = "\(distance) km"
        self.city = city
        self.state = state
    }
    
    static func zipCodes(jsonObject: JSON) -> [ZipCode] {
        var zipCodes: [ZipCode] = []
        
        guard let array = jsonObject["zip_codes"].array else { return zipCodes }
        for item in array{
            if let zipCode = try? ZipCode(jsonObject: item) {
                zipCodes.append(zipCode)
            }
        }
        
        return zipCodes
    }
}
