//
//  RequestBasicInfoModel.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/3.
//

import Foundation

protocol RequestBasicInfoModelDelegate: AnyObject {
    func didRecieveCompanyInfo(_ companyList: [StockBasicInfo], error: Error?)
    func didUpdateFiltedList()
}

class RequestBasicInfoModel {
    
    weak var delegate: RequestBasicInfoModelDelegate?
    
    private var isFiltering = false
    
    var filterText = "" {
        didSet {
            updateFilteringState()
        }
    }
    
    var recievedInfo = [MarketType]()
    
    var companyList = [StockBasicInfo]()
    
    var filtedList = [StockBasicInfo]()
    
    var count: Int {
        
        if isFiltering {
            return filtedList.count
        }
        return companyList.count
    }
    
    private lazy var stockInfoManager: StockInfoManager = {
        let manager = StockInfoManager()
        return manager
    }()
    
    private func updateFilteringState() {
        
        if filterText.count > 0 {
            isFiltering = true
            filtedList = companyList.filter({ basicInfo in
                
                return basicInfo.stockCode.contains(filterText) ||
                    basicInfo.stockName.contains(filterText) ||
                    basicInfo.companyName.contains(filterText)
            })
        } else {
            isFiltering = false
        }
        
        delegate?.didUpdateFiltedList()
    }
    
    private func updateStockInfo(from list: [StockBasicInfo], marketType: MarketType) {
        
        recievedInfo.append(marketType)
        
        let recievedList = Set(list)
        let updatedList = Set(companyList).union(recievedList)
        
        companyList = Array(updatedList).sorted { $0.stockCode < $1.stockCode }
    }
    
    private func getCompanyFromAll(at indexPath: IndexPath) -> StockBasicInfo? {
        
        let index = indexPath.row
        
        if companyList.indices.contains(index) {
            return companyList[index]
        }
        return nil
    }
    
    private func getCompanyFromFilter(at indexPath: IndexPath) -> StockBasicInfo? {
        
        let index = indexPath.row
        
        if filtedList.indices.contains(index) {
            return filtedList[index]
        }
        return nil
    }
    
    func getStockInfo(at indexPath: IndexPath) -> StockBasicInfo? {
        
        if isFiltering {
            return getCompanyFromFilter(at: indexPath)
        } else {
            return getCompanyFromAll(at: indexPath)
        }
    }
    
    func requestTwStock() {
        
        if recievedInfo.contains(.twStock) {
            print("已經拿過資料")
            return
        }
        
        stockInfoManager.requestTwStockCodeAndName { [weak self] list, error in
            self?.updateStockInfo(from: list, marketType: .twStock)
            self?.delegate?.didRecieveCompanyInfo(list, error: error)
        }
    }
    
    func requestOTCStock() {
        
        if recievedInfo.contains(.otc) {
            print("已經拿過資料")
            return
        }
        
        stockInfoManager.requestOTCCodeAndName { [weak self] list, error in
            self?.updateStockInfo(from: list, marketType: .otc)
            self?.delegate?.didRecieveCompanyInfo(list, error: error)
        }
    }
    
    func requestEmergingStock() {
        
        if recievedInfo.contains(.emerging) {
            print("已經拿過資料")
            return
        }
        
        stockInfoManager.requestEmerginCodeAndName { [weak self] list, error in
            self?.updateStockInfo(from: list, marketType: .emerging)
            self?.delegate?.didRecieveCompanyInfo(list, error: error)
        }
    }
}
