//
//  CurrencyDashboardViewController.swift
//  Crypto Market
//
//  Created by Kévin Leroyer on 18-03-02.
//  Copyright © 2018 Kévin Leroyer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftChart

class CurrencyDashboardViewController: UIViewController {

    @IBOutlet weak var chart: Chart!
    
    let defaults = UserDefaults.standard
    var nativeCurrency : [String: Any] = [:]

    var selectedCurrency : [String : String]? {
        didSet{
            nativeCurrency = defaults.dictionary(forKey: "nativeCurrency")!
            loadCurrencyChartData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = (selectedCurrency?["name"])! + " Price"
    }
    
    let historyEndpoint = "https://apiv2.bitcoinaverage.com/indices/global/history/"
    let tickerEndpoint = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"

    var finalURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.showXLabelsAndGrid = false
    }
    
    //MARK: - Chart Data
    
    func loadCurrencyChartData(period: String = "daily") {
        
        guard let currencyShortName = selectedCurrency?["shortName"]! else { fatalError() }

        let defaultCurrency = nativeCurrency["shortName"] as! String
        finalURL = historyEndpoint + currencyShortName + defaultCurrency + "?period=" + period
        
        Alamofire.request(finalURL, method: .get)
            .responseJSON { (response) in
                if response.result.isSuccess {
                    let currencyData : JSON = JSON(response.result.value!)
                    self.updateChart(json: currencyData)
                }
        }
    }
    
    func updateChart(json: JSON) {
        chart.removeAllSeries()
        var chartData : [Double] = []
        for (_, subJson):(String, JSON) in json {
            if let average = subJson["average"].double {
                chartData.append(average)
            }
        }
        let series = ChartSeries(chartData)
        series.area = true
        chart.add(series)
    }
    
    //MARK: Period Button Pressed
    
    @IBAction func periodButtonPressed(_ sender: UIButton) {
        if sender.tag == 1 {
            loadCurrencyChartData()
        } else if sender.tag == 2 {
            loadCurrencyChartData(period: "monthly")
        } else if sender.tag == 3 {
            loadCurrencyChartData(period: "alltime")
        }
    }
}
