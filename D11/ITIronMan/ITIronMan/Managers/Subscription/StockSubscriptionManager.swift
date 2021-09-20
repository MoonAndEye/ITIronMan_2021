//
//  StockSubscriptionManager.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/4.
//

import Foundation

/// 這個類別專門處理股票申購資訊
class StockSubscriptionManager {
    
    private lazy var alamofireAdapter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()
    
    func requestStockSubscriptionInfo(year: Int, completion: @escaping (([StockSubscriptionInfo], Error?) -> Void)) {
        
        let urlString = "https://www.twse.com.tw/announcement/publicForm?response=csv&yy=\(year)"
        
        alamofireAdapter.request(urlString, method: .get) { data, response, error in
            
            if let error = error {
                completion([], error)
                return
            }
            
            var subscriptionList = [StockSubscriptionInfo]()
            
            if let data = data,
               let string = String.dataWtihBig5(data: data) {
                
                let trimmedString = CSVAdapter.removeLine(string, at: 1)
                
                if let csv = try? CSVAdapter(rawString: trimmedString) {
                 
                    for each in csv.namedRows {
                        
                        let stockCode = each["證券代號"] ?? ""
                        let stockName = each["證券名稱"] ?? ""
                        let subscriptionStartString = each["申購開始日"] ?? ""
                        let subscriptionEndString = each["申購結束日"] ?? ""
                        let subscriptionOccurString = each["抽籤日期"] ?? ""
                        let price = each["承銷價(元)"] ?? ""
                        let actualPrice = each["實際承銷價(元)"] ?? ""
                        let stockDeliveringDateString = each["撥券日期(上市、上櫃日期)"] ?? ""
                        let stockCountString = each["承銷股數"] ?? ""
                        let totalApplyCountString = each["實際承銷股數"] ?? ""
                        let subscriptionRateString = each["中籤率(%)"] ?? ""
                        
                        let subscription = StockSubscriptionInfo(
                            stockCode: stockCode,
                            stockName: stockName,
                            subscriptionStartString: subscriptionStartString,
                            subscriptionEndString: subscriptionEndString,
                            subscriptionOccurString: subscriptionOccurString,
                            price: price,
                            actualPrice: actualPrice,
                            stockDeliveringDateString: stockDeliveringDateString,
                            stockCountString: stockCountString,
                            totalApplyCountString: totalApplyCountString,
                            subscriptionRateString: subscriptionRateString)
                        
                        subscriptionList.append(subscription)
                    }
                }
            }
               
            completion(subscriptionList, error)
        }
    }
}

