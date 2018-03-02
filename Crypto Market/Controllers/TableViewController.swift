//
//  TableViewController.swift
//  Crypto Market
//
//  Created by Kévin Leroyer on 18-03-02.
//  Copyright © 2018 Kévin Leroyer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UITableViewController {

    let currencies = [
        ["BTC": "Bitcoin"],
        ["BCH": "Bitcoin Cash"],
        ["ETH": "Ethereum"],
        ["LTC": "Litecoin"]
    ]
    let nativeCurrency = ["CAD": "$"]
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    
    var finalURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomCurrencyCell", bundle: nil), forCellReuseIdentifier: "customCurrencyCell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "customCurrencyCell", for: indexPath) as! CustomCurrencyCell
        
        finalURL = baseURL + currencies[indexPath.row].keys.first! + nativeCurrency.keys.first!

        Alamofire.request(finalURL, method: .get)
            .responseJSON { (response) in
                if response.result.isSuccess {
                    let currencyData = JSON(response.result.value!)
                    if let valueResult = currencyData["ask"].double {

                        let currency = self.currencies[indexPath.row]
                        let currencyValue = String(format: "%.2f", valueResult)
                        let currencySymbol = self.nativeCurrency.values.first!
                        let currencyChangePrice = String(format: "%.2f", currencyData["changes"]["price"]["day"].double!)
                        let currencyChangePercent = String(format: "%.2f", currencyData["changes"]["percent"]["day"].double!)

                        cell.currencyValue.text = "\(currencyValue) \(currencySymbol)"
                        cell.currencyName.text = currency.values.first!
                        cell.currencyShortName.text = currency.keys.first!
                        cell.currencyChange.text = "\(currencyChangePrice) \(currencySymbol) (\(currencyChangePercent)%)"

                        cell.currencyValue.sizeToFit()
                        cell.currencyName.sizeToFit()
                        cell.currencyShortName.sizeToFit()
                        cell.currencyChange.sizeToFit()
                    }
                }
        }

        return cell
    }
}
