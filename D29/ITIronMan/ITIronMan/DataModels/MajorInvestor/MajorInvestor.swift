//
//  MajorInvestor.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/15.
//

import Foundation

/// 三大法人，有分出避險與外資自營商
enum MajorInvestorType {
    case dealersForProprietary //自營商自行買賣
    case dealersHedge//自營商(避險)
    case securitiesInvestorForTrust//投信
    case foreignInvestorWithoutForeignDealer // 外資及陸資不含外資自營商
    case foreignDealers //外資自營商
    case total //總計
    case notOnList
}

struct MajorInvestor {

    let typeString: String
    let date: Date
    let totalBuyString: String
    let totalSellString: String
    let diffString: String
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var totalBuy: Double {
        return numberFormatter.number(from: totalBuyString)?.doubleValue ?? 0
    }
    
    var totalSell: Double {
        return numberFormatter.number(from: totalSellString)?.doubleValue ?? 0
    }
    
    var difference: Double {
        return numberFormatter.number(from: diffString)?.doubleValue ?? 0
    }
}

/// 只有三大法人，沒有細項
enum ThreeMajorInvestorType {
    case dealers //自營商
    case securitiesInvestorForTrust //投信
    case foreign //外資
    case total //總計
}

class ThreeMajorInvestorInfo {
    
    let type : ThreeMajorInvestorType
    var totalBuy: Double = 0
    var totalSell: Double = 0
    var difference: Double = 0
    
    init(type: ThreeMajorInvestorType) {
        self.type = type
    }
    
    func getItemName() -> String {
        
        switch type {
        case .foreign:
            return "外資"
        case .dealers:
            return "自營"
        case .securitiesInvestorForTrust:
            return "投資"
        case .total:
            return "總合"
        }
    }
}

struct TotalMajorInvestorInfo {
    
    let dealers: ThreeMajorInvestorInfo
    let securitiesInvestorForTrust: ThreeMajorInvestorInfo
    let foreign: ThreeMajorInvestorInfo
    let total: ThreeMajorInvestorInfo
}
