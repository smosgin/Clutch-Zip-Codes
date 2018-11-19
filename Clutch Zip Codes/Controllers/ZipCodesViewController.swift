//
//  ViewController.swift
//  Clutch Zip Codes
//
//  Created by Seth Mosgin on 10/15/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit
import SwiftyJSON

class ZipCodesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView?
    @IBOutlet var zipCodeTextField: UITextField?
    @IBOutlet var distanceTextField: UITextField?
    
    let API_URL = "https://www.zipcodeapi.com/rest/"
    let API_KEY = "WvwyMHS3LZYtiTiHu4UgbR9hKVC9I87SZZM0BWGgww8NiqaOFIQjf5WuTTyqq8fQ"
    
    var networkService: NetworkService?
    var dataSource: ZipCodesDataSource?
    var errorMessage = ""
    var selectedZipCode = ""
    var selectedDistance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView?.rowHeight = 100
        tableView?.delegate = dataSource
        tableView?.dataSource = dataSource
        updateZipData(json: TestData.testJSON)
    }
    
    //viewDidAppear, since this generates animations. Generating animations in -viewWillAppear can lead to graphic artifacts, since you're not on the screen yet. Since you almost certainly want it every time you come on screen, -viewDidLoad is likely redundant (it happens every time the view is loaded from disk, which is somewhat unpredictable, so isn't a good place for visual effects).
    override func viewDidAppear(_ animated: Bool) {
        //Tell the textField to be the first responder when the view appears so the user can start typing right away
        zipCodeTextField?.becomeFirstResponder()
    }
    
    //MARK: - Handle User Input
    /***************************************************************/
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        if let input = zipCodeTextField?.text, let _ = Int(input), let distance = distanceTextField?.text {
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
                networkService?.retrieveContents(url: buildURL(zip: input, distance: distance)) { jsonData, errorMessage in
                    if let jsonData = jsonData {
                        self.updateZipData(json: jsonData)
                    }
                }
                zipCodeTextField?.resignFirstResponder()
                distanceTextField?.resignFirstResponder()
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
    
    //MARK: - Updating User of results
    /***************************************************************/
    
    func updateZipData(json : JSON) {
        guard let dataSource = dataSource else { return }
        dataSource.zipCodesToDisplay.removeAll()
        dataSource.zipCodesToDisplay = ZipCode.zipCodes(jsonObject: json)
        if dataSource.zipCodesToDisplay.isEmpty {
            // JSON parsing failed, but HTTP request succeeded. Invalid input? Invalid API key? Requests throttled?
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Reading data failed", message: "Double check your input and try again later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else if dataSource.zipCodesToDisplay.count == 1 && dataSource.zipCodesToDisplay[0].zipcode == selectedZipCode {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No other Zip Codes in Radius", message: "Try increasing the radius to see more results.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        dataSource.zipCodesToDisplay = dataSource.zipCodesToDisplay.filter { $0.zipcode != selectedZipCode }
        updateUI()
    }
    
    //MARK: - Update UI
    /***************************************************************/
    
    func updateUI() {
        // Update the UI/TableView on the main thread
        print("Update UI Called")
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }


}

