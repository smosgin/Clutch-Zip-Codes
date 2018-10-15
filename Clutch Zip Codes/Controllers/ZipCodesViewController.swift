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
    var selectedZipCode: Int?
    
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
    
    //I recommend -viewDidAppear:, since this generates animations. Generating animations in -viewWillAppear can lead to graphic artifacts, since you're not on the screen yet. Since you almost certainly want it every time you come on screen, -viewDidLoad is likely redundant (it happens every time the view is loaded from disk, which is somewhat unpredictable, so isn't a good place for visual effects).
    override func viewDidAppear(_ animated: Bool) {
        //Tell the textField to be the first responder when the view appears so the user can start typing right away
        zipCodeTextField.becomeFirstResponder()
    }
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        if let input = zipCodeTextField.text, let inputValue = Int(input) {
            //Data validation
            let digitsArray = input.compactMap{ Int(String($0)) }
            if digitsArray.count == 5 {
                //Call API with inputValue
                zipCodeTextField.resignFirstResponder()
            } else {
                let alert = UIAlertController(title: "Invalid Zip Code Format", message: "Zip code must be 5 digits (e.g. '21208')", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
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

