//
//  StockSubscriptionModel.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/4.
//

import Foundation

protocol StockSubscriptionModelDelegate: AnyObject {
    
    func didRecieveList(_ subscriptionList: [StockSubscriptionInfo], error: Error?)
}

/// 股票申購 VC 所需的 Model
class StockSubscriptionModel {
    
    weak var delegate: StockSubscriptionModelDelegate?
    
    var subscriptionList = [StockSubscriptionInfo]()
    
    private lazy var manager: StockSubscriptionManager = {
        return StockSubscriptionManager()
    }()
    
    var count: Int {
        return subscriptionList.count
    }
    
    // MARK: - private func
    private func filterNotAvailable(_ subscriptionList: [StockSubscriptionInfo]) -> [StockSubscriptionInfo] {
        
        let list = subscriptionList.filter { info in
            let code = info.stockCode
            let firstCharacter = code.first ?? "0"
            return firstCharacter != "A"
        }
        
        return list
    }
    
    private func getQueryYear() -> Int {
        
        let dateUtility = DateUtility()
        
        return dateUtility.getIntFromDate(component: .year)
    }
    
    // MARK: - public func
    func getSubscriptionInfo(at indexPath: IndexPath) -> StockSubscriptionInfo? {
        
        let index = indexPath.row
        
        if subscriptionList.indices.contains(index) {
            return subscriptionList[index]
        }
        
        return nil
    }
    
    func requestStockSubscription() {
        
        let year = getQueryYear()
        manager.requestStockSubscriptionInfo(year: year) { [weak self] subscriptionList, error in
            
            // 需要去掉中央債的資料
            self?.subscriptionList = self?.filterNotAvailable(subscriptionList) ?? []
            self?.delegate?.didRecieveList(subscriptionList, error: error)
        }
    }
    
    
}

extension StockSubscriptionModel {
    
    enum SubscriptionState {
        
        case beforeSubscription
        case duringSubscription
        case finishedSubscription
        case notDefined
    }
}

extension StockSubscriptionModel {
    
    func getSubscriptionState(info: StockSubscriptionInfo) -> SubscriptionState {
        
        let currentTime = Date().timeIntervalSince1970
        
        if let startTime = info.subscriptionStart?.timeIntervalSince1970,
           let endTime = info.subscriptionEnd?.timeIntervalSince1970 {
            
            if currentTime < startTime {
                return .beforeSubscription
            } else if currentTime > endTime {
                return .finishedSubscription
            } else {
                return .duringSubscription
            }
        }
        
        return .notDefined
    }
}
