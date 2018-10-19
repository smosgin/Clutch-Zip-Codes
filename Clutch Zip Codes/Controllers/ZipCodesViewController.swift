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
    @IBOutlet var distanceTextField: UITextField!
    
    let API_URL = "https://www.zipcodeapi.com/rest/"
    let API_KEY = "WvwyMHS3LZYtiTiHu4UgbR9hKVC9I87SZZM0BWGgww8NiqaOFIQjf5WuTTyqq8fQ"
    
//    let defaultSession = URLSession(configuration: .default)
//    var dataTask: URLSessionDataTask?
    let networkService = NetworkService()
    var errorMessage = ""
    var zipCodesToDisplay = [ZipCode]()
    var selectedZipCode = ""
    var selectedDistance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        updateZipData(json: TestData.testJSON)
    }
    
    //viewDidAppear, since this generates animations. Generating animations in -viewWillAppear can lead to graphic artifacts, since you're not on the screen yet. Since you almost certainly want it every time you come on screen, -viewDidLoad is likely redundant (it happens every time the view is loaded from disk, which is somewhat unpredictable, so isn't a good place for visual effects).
    override func viewDidAppear(_ animated: Bool) {
        //Tell the textField to be the first responder when the view appears so the user can start typing right away
        zipCodeTextField.becomeFirstResponder()
    }
    
    //MARK: - Handle User Input
    /***************************************************************/
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        if let input = zipCodeTextField.text, let _ = Int(input), let distance = distanceTextField.text {
            //Data validation for distance
            guard !distance.isEmpty else {
                let alert = UIAlertController(title: "Invalid Distance Format", message: "Distance text field must not be empty (e.g. '10')", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            //Data validation for zip code
            let digitsArray = input.compactMap{ Int(String($0)) }
            if digitsArray.count == 5 {
                //Call API with input
                selectedZipCode = input
                selectedDistance = distance
                networkService.retrieveNews(url: buildURL(zip: input, distance: distance)) { jsonData, errorMessage in
                    if let jsonData = jsonData {
                        self.updateZipData(json: jsonData)
                    }
                }
                zipCodeTextField.resignFirstResponder()
                distanceTextField.resignFirstResponder()
            } else {
                let alert = UIAlertController(title: "Invalid Zip Code Format", message: "Zip code must be 5 digits (e.g. '21208')", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Perform HTTP Request
    /***************************************************************/
    
    func buildURL(zip: String, distance: String) -> String {
         return "\(API_URL)\(API_KEY)/radius.json/\(zip)/\(distance)/km"
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateZipData(json : JSON) {
        //We could get a situation where the connection was successful but the App key was invalid
        guard json["zip_codes"][0]["distance"].double != nil else { return }
        if let zipCodesJSON = json["zip_codes"].array {//Convenience provided by SwiftyJSON
            
            zipCodesToDisplay.removeAll()
            print("\(zipCodesJSON.count) Number of zip codes")
            for zipcode in zipCodesJSON {
                if let zipCodeNumber = zipcode["zip_code"].string {
                    print(zipCodeNumber)
                    //publishedAt, urlToImage, url, author, description, source : {id, name}, title
                    guard let distance = zipcode["distance"].double else { continue }
                    
                    if zipCodeNumber == selectedZipCode { continue }
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
            // JSON parsing failed, but HTTP request succeeded. Invalid input? Invalid API key? Requests throttled?
            let alert = UIAlertController(title: "Reading data failed", message: "Double check your input and try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ZipCodeCell", for: indexPath) as? ZipCodeCell else {
            fatalError("Cell is not of type ZipCodeCell")
        }
        
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

