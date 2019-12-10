//
//  ExchangeRatesTableVC.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 10.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit
import SwiftSpinner

class ExchangeRatesTableVC: UITableViewController {
    
    let viewModel = ExchangeRatesViewModel()
    private let showExchangeRateGraphSegue = "showExchangeRateGraphSegue"
    private let exchangeRatesIdentifier = "ExchangeRatesIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Setup spinner
        SwiftSpinner.setTitleColor(.lightGray)
        SwiftSpinner.showBlurBackground = false
        SwiftSpinner.shared.outerColor = .lightGray
        SwiftSpinner.show("Loading data...")
        
        // Data loaded, reload tableView
        viewModel.showExchangeRateUSD { [weak self] in
            self?.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: exchangeRatesIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        let rate = viewModel.rates[indexPath.row]
        let exchangeRate = String(format: "%.2f", rate.exchangeRate)
        cell.textLabel?.text = rate.currencyName + "\n" + exchangeRate
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: showExchangeRateGraphSegue, sender: self)
    }

   
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == showExchangeRateGraphSegue,
            let destination = segue.destination as? ExchangeRateGraphVC,
            let rateIndex = tableView.indexPathForSelectedRow?.row {
            let rate = viewModel.rates[rateIndex]
            destination.viewModel.apiClient = viewModel.apiClient
            destination.viewModel.symbols = rate.currencyName
        }
    }
}
