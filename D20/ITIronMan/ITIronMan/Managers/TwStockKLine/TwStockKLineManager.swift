//
//  TwStockKLineManager.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/7.
//

import Foundation

//加權指數-公開資訊觀測站 https://www.twse.com.tw/zh/page/trading/indices/MI_5MINS_HIST.html
// https://www.twse.com.tw/en/indicesReport/MI_5MINS_HIST?response=csv&date=20210907
class TwStockKLineManager {
    
    private var dateUtility: DateUtility {
        return DateUtility()
    }
    
    private lazy var alamofireAdapter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()
    
    func requestTwStockKLine(date: Date, completion: @escaping (([StockKLine], Error?) -> Void)) {
        
        let format = "yyyyMMdd"
        let string = dateUtility.getString(date: date, format: format)
        
        let urlString = "https://www.twse.com.tw/en/indicesReport/MI_5MINS_HIST?response=csv&date=\(string)"
        
        alamofireAdapter.requestForString(urlString, method: .get) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let string):
                let kLineDataSet = self.convertToKLineList(string)
                completion(kLineDataSet, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    private func convertToKLineList(_ string: String) -> [StockKLine] {
        
        var kLineDataSet = [StockKLine]()
        
        let trimmedString = trimmedFirstLine(string)
        
        if let csv = try? CSVAdapter(rawString: trimmedString) {
            
            for each in csv.namedRows {
                
                let stockCode = "taiex"
                let stockName = "台股加權指數"
                
                let dateString = each["Date"] ?? ""
                let openString = each["Opening Index"] ?? ""
                let highestString = each["Highest Index"] ?? ""
                let lowestString = each["Lowest Index"] ?? ""
                let closeString = each["Closing Index"] ?? ""
                
                let kLine = StockKLine(stockCode: stockCode, stockName: stockName, dateString: dateString, openString: openString, highestString: highestString, lowestString: lowestString, closeString: closeString)
                
                kLineDataSet.append(kLine)
            }
        }
        
        return kLineDataSet
    }
    
    private func trimmedFirstLine(_ string: String) -> String {
        
        return CSVAdapter.removeLine(string, at: 1)
    }
}
