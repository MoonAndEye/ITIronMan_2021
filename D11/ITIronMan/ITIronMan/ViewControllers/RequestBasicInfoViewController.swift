//
//  RequestBasicInfoViewController.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/3.
//

import UIKit

class RequestBasicInfoViewController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterTextField: UITextField!
    
    private lazy var model: RequestBasicInfoModel = {
        let model = RequestBasicInfoModel()
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
        tableView.delegate = self
        tableView.dataSource = self
        filterTextField.addTarget(self, action: #selector(filterStock), for: .editingChanged)
    }
    
    @objc private func filterStock() {
        
        if filterTextField.hasText,
           let text = filterTextField.text {
            
            model.filterText = text
        } else {
            model.filterText = ""
        }
    }
    
    // MARK: - IBAction
    @IBAction func requestTwStockButtonDidTap(_ sender: Any) {
        
        model.requestTwStock()
    }
    
    @IBAction func requestOTCButtonDidTap(_ sender: Any) {
        
        model.requestOTCStock()
    }
    
    @IBAction func requestEmergingButtonDidTap(_ sender: Any) {
        
        model.requestEmergingStock()
    }
}

extension RequestBasicInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CompanyBasicInfoTableViewCell.identifier, for: indexPath) as? CompanyBasicInfoTableViewCell,
              let info = model.getStockInfo(at: indexPath) else {
            return UITableViewCell()
        }
        
        let codeName = "\(info.stockName) - (\(info.stockCode))\n\(info.companyName)"
        
        let capital = "資本額: \(info.capital) 元"
        
        cell.codeAndNameLabel.text = codeName
        cell.capitalLabel.text = capital
        
        return cell
    }
}

extension RequestBasicInfoViewController: RequestBasicInfoModelDelegate {
    
    func didUpdateFiltedList() {
        tableView.reloadData()
    }
    
    func didRecieveCompanyInfo(_ companyList: [StockBasicInfo], error: Error?) {
        
        if let error = error {
            
            print("basic info reqeust got error: \(error.localizedDescription)")
            return
        }
        
        updateStateUI()
        
        tableView.reloadData()
    }
    
    private func updateStateUI() {
        
        var recievedMarketsText = ""
        
        for market in model.recievedInfo {
            recievedMarketsText += "\(market.rawValue)  "
        }
        
        stateLabel.text = "已取得 \(recievedMarketsText) 資料 - 數量 \(model.count) 筆"
    }
}
