//
//  Clutch_Zip_CodesTests.swift
//  Clutch Zip CodesTests
//
//  Created by Seth Mosgin on 11/8/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import XCTest
@testable import Clutch_Zip_Codes

class Clutch_Zip_CodesTests: XCTestCase {

    var networkServiceUnderTest: NetworkService!
    var urlSessionUnderTest: URLSession!
    var vcUnderTest: ZipCodesViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkServiceUnderTest = ZipCodesAPIService()
        urlSessionUnderTest = URLSession(configuration: .default)
        vcUnderTest = ZipCodesViewController(nibName: nil, bundle: nil)
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkServiceUnderTest = nil
        urlSessionUnderTest = nil
        vcUnderTest = nil
        super.tearDown()
    }

    func testValidCallToAPIGetsHTTPStatusCode200() {
        let url = URL(string: vcUnderTest.buildURL(zip: "21208", distance: "5"))

        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = urlSessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
