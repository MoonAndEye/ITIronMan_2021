//
//  StockKLine.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/7.
//

import Foundation

struct StockKLine: Hashable {
    
    let stockCode: String
    let stockName: String
    
    let dateString: String
    
    let openString: String
    let highestString: String
    let lowestString: String
    let closeString: String
    
    private var dateUtility: DateUtility {
        return DateUtility()
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var date: Date? {
        return dateUtility.getDate(from: dateString, format: "yyyy/MM/dd")
    }
    
    var open: Double? {
        return numberFormatter.number(from: openString)?.doubleValue
    }
    
    var highest: Double? {
        return numberFormatter.number(from: highestString)?.doubleValue
    }
    
    var lowest: Double? {
        return numberFormatter.number(from: lowestString)?.doubleValue
    }
    
    var close: Double? {
        return numberFormatter.number(from: closeString)?.doubleValue
    }
}
