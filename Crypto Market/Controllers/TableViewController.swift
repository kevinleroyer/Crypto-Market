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

    let defaults = UserDefaults.standard

    let currencies = [
        ["shortName": "BTC", "name": "Bitcoin"],
        ["shortName": "BCH", "name": "Bitcoin Cash"],
        ["shortName": "ETH", "name": "Ethereum"],
        ["shortName": "LTC", "name": "Litecoin"]
    ]

    var nativeCurrency : [String: Any] = [:]
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    
    var finalURL = ""
    
    lazy var refreshValuesControl: UIRefreshControl = {
        let refreshValuesControl = UIRefreshControl()
        refreshValuesControl.addTarget(self, action: #selector(TableViewController.handleRefresh(_:)),for: UIControlEvents.valueChanged)
        return refreshValuesControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomCurrencyCell", bundle: nil), forCellReuseIdentifier: "customCurrencyCell")
        tableView.rowHeight = 80.0
        tableView.addSubview(self.refreshValuesControl)
        
        nativeCurrency = defaults.dictionary(forKey: "nativeCurrency")!
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        nativeCurrency = defaults.dictionary(forKey: "nativeCurrency")!

        let cell = tableView.dequeueReusableCell(withIdentifier: "customCurrencyCell", for: indexPath) as! CustomCurrencyCell
        
        let defaultCurrency = nativeCurrency["shortName"] as! String
        finalURL = baseURL + currencies[indexPath.row]["shortName"]! + defaultCurrency
        
        Alamofire.request(finalURL, method: .get)
            .responseJSON { (response) in
                if response.result.isSuccess {
                    let currencyData = JSON(response.result.value!)
                    if let valueResult = currencyData["ask"].double {

                        let currency = self.currencies[indexPath.row]
                        let currencyValue = String(format: "%.2f", valueResult)
                        let currencySymbol = self.nativeCurrency["symbol"]!
                        let currencyChangePrice = String(format: "%.2f", currencyData["changes"]["price"]["day"].double!)
                        let currencyChangePercent = String(format: "%.2f", currencyData["changes"]["percent"]["day"].double!)

                        cell.currencyValue.text = "\(currencyValue) \(currencySymbol)"
                        cell.currencyName.text = currency["name"]!
                        cell.currencyShortName.text = currency["shortName"]!
                        cell.currencyChange.text = "\(currencyChangePrice) \(currencySymbol) (\(currencyChangePercent)%)"
                    }
                }
        }

        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCurrencyDashboard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CurrencyDashboardViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCurrency = currencies[indexPath.row]
        }
    }
}
