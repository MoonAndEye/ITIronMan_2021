//
//  KLineViewController.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/8.
//

import UIKit

class KLineViewController: UIViewController {
    
    @IBOutlet weak var chartContainer: UIView!
    
    private lazy var chartsAdapter: ChartsAdapter = {
        return ChartsAdapter()
    }()
    
    private lazy var chartView: UIView = {
        let view = chartsAdapter.getCombineChartView()
        return view
    }()
    
    var kLineDataSet = [StockKLine]()
    
    var volumeDataSet = [TwMarketTradingInfo]()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasicUI()
        setupCandleView()
    }
    
    // MARK: - private methods
    private func setupBasicUI() {
        
        chartContainer.backgroundColor = .clear
        
        chartContainer.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        chartView.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: chartContainer.topAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor).isActive = true
    }
    
    private func setupCandleView() {
        
        chartsAdapter.updateWithMALine(stockSticks: kLineDataSet, volumeDataList: volumeDataSet, combinedView: chartView)
    }
}

