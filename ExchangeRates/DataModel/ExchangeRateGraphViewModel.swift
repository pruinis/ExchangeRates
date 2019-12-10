//
//  ExchangeRateGraphViewModel.swift
//  ExchangeRates
//
//  Created by Anton Morozov on 10.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import Foundation
import Charts

class ExchangeRateGraphViewModel {

    weak var apiClient: ApiClient?
    weak var chartView: LineChartView?
    weak var axisFormatDelegate: IAxisValueFormatter?

    var symbols: String?
    var rates = [Rate]()

    func fetchLastWeekHistoryUSD(chartView: LineChartView, completion: @escaping () -> Void) {
        
        self.chartView = chartView

        guard let symbols = symbols else {
            completion()
            return
        }

        apiClient?.fetchLastWeekHistoryUSD(symbols: symbols) { [weak self] (result) in
            
            DispatchQueue.main.async {
                self?.rates.removeAll()
                switch result {
                case .success(let historyRate):
                    self?.rates.append(contentsOf: historyRate.rates)
                    self?.setupChart()
                case .failure: break
                }
                completion()
            }            
        }
    }    
    
    func setupChart() {        
        rates.sort(by: { $0.date.compare($1.date) == .orderedAscending })

        axisFormatDelegate = self
        var dataEntries = [ChartDataEntry]()
        for i in 0..<rates.count {
            let rate = rates[i]
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(rate.exchangeRate), data: rates)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Exchange Rate for \(symbols ?? "")")
        let chartData = LineChartData(dataSet: chartDataSet)
        let xAxisValue = chartView?.xAxis
        xAxisValue?.valueFormatter = axisFormatDelegate
        xAxisValue?.granularity = 1
        chartView?.data = chartData
    }
}

extension ExchangeRateGraphViewModel: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let rate = rates[Int(value)]
        return rate.date.stringDate()
    }
}
