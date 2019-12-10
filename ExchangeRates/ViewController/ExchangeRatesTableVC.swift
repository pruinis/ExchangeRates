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
                
        SwiftSpinner.show("Loading data...")
        viewModel.fetchLatestExchangeRateUSD { [weak self] in
            self?.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exchangeRate?.rates.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: exchangeRatesIdentifier, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        let rates = viewModel.exchangeRate?.rates
        if let rate = rates?[indexPath.row] {
            let exchangeRate = String(format: "%.2f", rate.exchangeRate)
            cell.textLabel?.text = rate.currencyName + "\n" + exchangeRate
        }
        else {
            cell.textLabel?.text = nil
        }

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
            
            
            let rates = viewModel.exchangeRate?.rates
            if let rate = rates?[rateIndex] {
                destination.viewModel.apiClient = viewModel.apiClient
                destination.viewModel.symbols = rate.currencyName
            }
        }
    }
}
