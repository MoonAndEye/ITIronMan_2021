//
//  TwMarketTradingInfo.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/10.
//

import Foundation

struct TwMarketTradingInfo: Hashable {
    
    let date: Date
    let tradeVolumeString: String
    let tradeValueString: String
    let transactionString: String
    let taiexString: String
    let changeString: String
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var value: Double? {
        return numberFormatter.number(from: tradeValueString)?.doubleValue
    }
    
    /// 單位是億
    var twValue: Double? {
        if let value = value {
            return value / Double(100_000_000)
        }
        return nil
    }
    
    var volume: Double? {
        return numberFormatter.number(from: tradeVolumeString)?.doubleValue
    }
    
    var transaction: Double? {
        return numberFormatter.number(from: transactionString)?.doubleValue
    }
    
    var taiex: Double? {
        return numberFormatter.number(from: taiexString)?.doubleValue
    }
    
    var change: Double? {
        return numberFormatter.number(from: changeString)?.doubleValue
    }
}
