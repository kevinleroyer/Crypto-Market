//
//  SettingsTableViewController.swift
//  Crypto Market
//
//  Created by Kévin Leroyer on 18-03-15.
//  Copyright © 2018 Kévin Leroyer. All rights reserved.
//

import UIKit
import ProgressHUD

class NativeCurrencySettingsTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var nativeCurrency : [String: Any] = [:]

    let currencies = [
        ["name": "Canadian Dollar", "shortName": "CAD", "symbol": "$"],
        ["name": "US Dollar", "shortName": "USD", "symbol": "$"],
        ["name": "Euro", "shortName": "EUR", "symbol": "€"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nativeCurrency = defaults.dictionary(forKey: "nativeCurrency")!
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nativeCurrencyCell", for: indexPath)
        cell.textLabel?.text = "\(currencies[indexPath.row]["name"]!) (\(currencies[indexPath.row]["symbol"]!))"
        let defaultCurrency = nativeCurrency["shortName"] as! String
        if currencies[indexPath.row]["shortName"] == defaultCurrency {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(currencies[indexPath.row], forKey: "nativeCurrency")
        ProgressHUD.showSuccess("Saved")
        navigationController?.popToRootViewController(animated: true)
    }

}
