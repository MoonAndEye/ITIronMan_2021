//
//  StockSubscriptionInfo.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/4.
//

import Foundation

/// 股票申購最小單位的 data model
struct StockSubscriptionInfo {
    
    var dateUtility: DateUtility {
        return DateUtility()
    }
    
    let stockCode: String
    let stockName: String
    let subscriptionStartString: String
    let subscriptionEndString: String
    let subscriptionOccurString: String
    
    /// 承銷價
    let price: String
    
    /// 實際承銷價，不確定為什麼會有這個欄位，但看起來價格和承銷價一樣
    let actualPrice: String
    
    let stockDeliveringDateString: String
    
    let stockCountString: String
    
    /// 總合格件數，所有被扣款成功的數量
    let totalApplyCountString: String
    
    /// 中籤率
    let subscriptionRateString: String
    
    var subscriptionStart: Date? {
        return dateUtility.getDateFromTwCalendar(from: subscriptionStartString)
    }
    
    var subscriptionEnd: Date? {
        return dateUtility.getDateFromTwCalendar(from: subscriptionEndString)
    }
}
