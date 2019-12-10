//
//  ExchangeRateGraphVC.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 10.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import Charts
import SwiftSpinner

class ExchangeRateGraphVC: UIViewController {
    
    @IBOutlet weak var chartView: LineChartView!    
    
    var viewModel = ExchangeRateGraphViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.symbols
               
        SwiftSpinner.show("Loading data...")
        viewModel.fetchLastWeekHistoryUSD(chartView: chartView) {            
            SwiftSpinner.hide {
                self.showEmptyDataPopupIfNeeded()
            }
        }
    }
    
    func showEmptyDataPopupIfNeeded() {
        if viewModel.rates.isEmpty {
            DispatchQueue.main.async {
                let title = "No exchange rate data is available for the selected currency."
                let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
