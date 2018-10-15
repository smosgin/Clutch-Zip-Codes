//
//  ViewController.swift
//  Clutch Zip Codes
//
//  Created by Seth Mosgin on 10/15/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ZipCodesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var zipCodeTextField: UITextField!
    
    let API_URL = ""
    let API_KEY = ""
    
    var zipCodesToDisplay = [ZipCode]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        updateZipData(json: testJSON)
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateZipData(json : JSON) {
        //We could get a situation where the connection was successful but the App key was invalid
        guard json["zip_codes"][0]["distance"].double != nil else { return }
        if let zipCodesJSON = json["zip_codes"].array {//Convenience provided by SwiftyJSON
            
            print("\(zipCodesJSON.count) Number of zip codes")
            for zipcode in zipCodesJSON {
                if let zipCodeNumber = zipcode["zip_code"].string {
                    print(zipCodeNumber)
                    //publishedAt, urlToImage, url, author, description, source : {id, name}, title
                    guard let distance = zipcode["distance"].double else { continue }
                    
                    let item = ZipCode()
                    item.zipcode = zipCodeNumber
                    item.distance = "\(distance) km"
                    item.city = zipcode["city"].stringValue
                    print(item.city)
                    item.state = zipcode["state"].stringValue
                    
                    zipCodesToDisplay.append(item)
                } else {
                    continue
                }
            }
            
            updateUI()
            
        } else {
            // Would be good to have a default "API Unavailable" message here to the user
        }
    }
    
    //MARK: - Update UI
    /***************************************************************/
    
    func updateUI() {
        // Update the UI/TableView on the main thread
        print("Update UI Called")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - TableView Datasource Methods
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZipCodeCell", for: indexPath) as! ZipCodeCell
        
        let item = zipCodesToDisplay[indexPath.row]
        cell.zipCodeLabel.text = item.zipcode
        cell.distanceLabel.text = item.distance
        cell.cityLabel.text = item.city
        cell.stateLabel.text = item.state
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipCodesToDisplay.count
    }


}

