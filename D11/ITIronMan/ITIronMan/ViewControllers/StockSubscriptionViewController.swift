//
//  StockSubscriptionViewController.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/4.
//

import UIKit

class StockSubscriptionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var model: StockSubscriptionModel = {
        let model = StockSubscriptionModel()
        model.delegate = self
        return model
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - private methods
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - IBAction
    @IBAction func requestSubscriptionButtonDidTap(_ sender: Any) {
        model.requestStockSubscription()
    }
    
}

extension StockSubscriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockSubscriptionTableViewCell.identifier, for: indexPath) as? StockSubscriptionTableViewCell,
              let info = model.getSubscriptionInfo(at: indexPath) else {
            return UITableViewCell()
        }
        
        let state = "申購狀態"
        let firstSection = "\(info.stockName) - (\(info.stockCode))"
        let secondSection = "申購股數: \(info.stockCountString)"
        let thirdSection = "申購價: \(info.actualPrice)"
        let forthSection = "中籤率: \(info.subscriptionRateString) %"
        
        cell.stateLabel.text = state
        cell.firstSectionLabel.text = firstSection
        cell.secondSectionLabel.text = secondSection
        cell.thirdSectionLabel.text = thirdSection
        cell.forthSectionLabel.text = forthSection
        
        modify(cell, with: info)
        
        return cell
    }
    
    private func modify(_ cell: StockSubscriptionTableViewCell, with info: StockSubscriptionInfo) {
        
        let state = model.getSubscriptionState(info: info)
        
        if info.subscriptionRateString == "0" {
            cell.forthSectionLabel.text = "-- %"
        }
        
        switch state {
        case .beforeSubscription:
            setBeforeSubscriptionUI(cell)
        case .duringSubscription:
            setDuringSubscriptionUI(cell)
        case .finishedSubscription:
            setFinishedSubscriptionUI(cell)
        case .notDefined:
            setNotDefinedUI(cell)
        }
    }
    private func setBeforeSubscriptionUI(_ cell: StockSubscriptionTableViewCell) {
        
        cell.stateLabel.text = "申購未開始"
        cell.stateLabel.textColor = .black
        cell.stateLabel.backgroundColor = .clear
    }
    
    private func setDuringSubscriptionUI(_ cell: StockSubscriptionTableViewCell) {
        
        cell.stateLabel.text = "可申購"
        cell.stateLabel.textColor = .systemGreen
        cell.stateLabel.backgroundColor = .clear
    }
    
    private func setFinishedSubscriptionUI(_ cell: StockSubscriptionTableViewCell) {
        
        cell.stateLabel.text = "申購結束"
        cell.stateLabel.textColor = .white
        cell.stateLabel.backgroundColor = .systemRed
    }
    
    private func setNotDefinedUI(_ cell: StockSubscriptionTableViewCell) {
        
        cell.stateLabel.text = "申購狀態未定"
        cell.stateLabel.textColor = .systemGray2
        cell.stateLabel.backgroundColor = .clear
    }
}

extension StockSubscriptionViewController: StockSubscriptionModelDelegate {
    
    func didRecieveList(_ subscriptionList: [StockSubscriptionInfo], error: Error?) {
        
        if let error = error {
            print("you got error during subscriptions request: \(error.localizedDescription)")
            return
        }
        
        tableView.reloadData()
    }
}
