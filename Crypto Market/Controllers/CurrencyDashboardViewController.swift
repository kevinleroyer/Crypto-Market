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
import SVProgressHUD

class CurrencyDashboardViewController: UIViewController {

    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var currencyPriceLabel: UILabel!
    @IBOutlet weak var currencyChangeLabel: UILabel!
    @IBOutlet weak var oneDayButton: UIButton!
    @IBOutlet weak var oneMonthButton: UIButton!
    @IBOutlet weak var allTimeButton: UIButton!
    
    let defaults = UserDefaults.standard
    var nativeCurrency : [String: Any] = [:]

    var currencyDataModel : CurrencyDataModel? {
        didSet{
            nativeCurrency = defaults.dictionary(forKey: "nativeCurrency")!
            loadCurrencyChartData()
        }
    }
    
    let historyEndpoint = "https://apiv2.bitcoinaverage.com/indices/global/history/"
    var finalURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        oneDayButton.isSelected = true
        chart.showXLabelsAndGrid = false
        
        setCurrencyData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = (currencyDataModel?.name)! + " Price"
    }
    
    //MARK: - Chart Data
    
    func loadCurrencyChartData(period: String = "daily") {
        
        guard let currencyShortName = currencyDataModel?.shortName else { fatalError() }

        let defaultCurrency = nativeCurrency["shortName"] as! String
        finalURL = historyEndpoint + currencyShortName + defaultCurrency + "?period=" + period
        
        Alamofire.request(finalURL, method: .get)
            .responseJSON { (response) in
                if response.result.isSuccess {
                    let currencyData : JSON = JSON(response.result.value!)
                    self.updateChart(json: currencyData)
                }
                SVProgressHUD.dismiss()
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
    
    // MARK: - Currency Data
    
    func setCurrencyData() {
        currencyChangeLabel.text = currencyDataModel!.changePrice + currencyDataModel!.symbol + " (" + currencyDataModel!.changePercent + "%)"
        currencyPriceLabel.text = currencyDataModel!.symbol + currencyDataModel!.value
    }
    
    // MARK: - Period Button Pressed
    
    @IBAction func periodButtonPressed(_ sender: UIButton) {
        unselectButtons()
        sender.isSelected = true
        SVProgressHUD.show()
        if sender.tag == 1 {
            loadCurrencyChartData()
        } else if sender.tag == 2 {
            loadCurrencyChartData(period: "monthly")
        } else if sender.tag == 3 {
            loadCurrencyChartData(period: "alltime")
        }
    }
    
    func unselectButtons() {
        oneDayButton.isSelected = false
        oneMonthButton.isSelected = false
        allTimeButton.isSelected = false
    }
}
