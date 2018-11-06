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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ZipCodeCell", for: indexPath) as? ZipCodeCell else {
            fatalError("Cell is not of type ZipCodeCell")
        }
        
        let item = zipCodesToDisplay[indexPath.row]
        cell.zipCodeLabel?.text = item.zipcode
        cell.distanceLabel?.text = item.distance
        cell.cityLabel?.text = item.city
        cell.stateLabel?.text = item.state
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipCodesToDisplay.count
    }
}
