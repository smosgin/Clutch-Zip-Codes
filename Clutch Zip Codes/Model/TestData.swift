//
//  TestData.swift
//  Clutch Zip Codes
//
//  Created by Seth Mosgin on 10/19/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TestData {
    let testJSON : JSON = [
        "zip_codes": [
            [
                "zip_code": "21260",
                "distance": 3.893,
                "city": "Baltimore",
                "state": "MD"
            ],
            [
                "zip_code": "21209",
                "distance": 4.472,
                "city": "Baltimore",
                "state": "MD"
            ],
            [
                "zip_code": "21208",
                "distance": 0,
                "city": "Pikesville",
                "state": "MD"
            ],
            [
                "zip_code": "21153",
                "distance": 4.468,
                "city": "Stevenson",
                "state": "MD"
            ]
        ]
    ]
}
