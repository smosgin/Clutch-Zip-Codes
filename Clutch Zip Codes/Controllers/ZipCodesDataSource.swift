//
//  ZipCodesDataSource.swift
//  Clutch Zip Codes
//
//  Created by Seth Mosgin on 11/5/18.
//  Copyright © 2018 Seth Mosgin. All rights reserved.
//

import UIKit



class ZipCodesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var zipCodesToDisplay = [ZipCode]()
    
    //MARK: - TableView Datasource Methods
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = zipCodesToDisplay[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ZipCodeCell", for: indexPath) as? ZipCodeCell {
            cell.zipCodeLabel?.text = item.zipcode
            cell.distanceLabel?.text = item.distance
            cell.cityLabel?.text = item.city
            cell.stateLabel?.text = item.state
            
            return cell
        } else {
            // Should probably be a fatalError during testing to test for inconsitencies. fatalError("Cell is not of type ZipCodeCell")
            print("cell was not dequeued")
            let cell = ZipCodeCell()
            cell.zipCodeLabel?.text = item.zipcode
            cell.distanceLabel?.text = item.distance
            cell.cityLabel?.text = item.city
            cell.stateLabel?.text = item.state
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipCodesToDisplay.count
    }
}
