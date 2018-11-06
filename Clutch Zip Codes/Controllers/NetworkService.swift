//
//  NetworkService.swift
//  Clutch Zip Codes
//
//  Created by Seth Mosgin on 10/19/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol NetworkService {
    
    func retrieveContents(url: String, completion: @escaping (JSON?, String) -> ())
    
}

class ZipCodesAPIService: NetworkService {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var errorMessage = ""
    
    func retrieveContents(url: String, completion: @escaping (JSON?, String) -> ()) {
        // If this gets called with a data task already in progress (e.g. user changes input before HTTP request finishes), cancel it
        dataTask?.cancel()
        
        guard let url = URL(string: url) else { print("Exiting; Invalid URL"); return }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            // 5
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                //Display a message to the user here for HTTP request failure
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                print(data)
                guard let jsonData = try? JSON(data: data) else { return }
                print(jsonData)
                completion(jsonData, self.errorMessage)
            }
        }
        dataTask?.resume()
    }
}
