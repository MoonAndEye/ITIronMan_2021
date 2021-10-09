//
//  TwMarketDealingInfo.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/10.
//

import Foundation

// https://www.twse.com.tw/en/exchangeReport/FMTQIK?response=csv&date=20210910
// 證交所 https://www.twse.com.tw/en/page/trading/exchange/FMTQIK.html
class TwMarketTradingInfoManager {
    
    private var dateUtility: DateUtility {
        return DateUtility()
    }
    
    private lazy var alamofireAdapter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()
    
    func requestTwMarketDailyTradingInfo(date: Date, completion: @escaping (([TwMarketTradingInfo], Error?) -> Void)) {
        
        let format = "yyyyMMdd"
        let string = dateUtility.getString(date: date, format: format)
        
        let urlString = "https://www.twse.com.tw/en/exchangeReport/FMTQIK?response=csv&date=\(string)"
        
        alamofireAdapter.requestForString(urlString, method: .get) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let string):
                let tradingInfoDataSet = self.convertToTwMarketTradingInfo(string)
                completion(tradingInfoDataSet, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    private func convertToTwMarketTradingInfo(_ string: String) -> [TwMarketTradingInfo] {
        
        var dataSet = [TwMarketTradingInfo]()
        
        let trimmedString = trimmedFirstLine(string)
        
        if let csv = try? CSVAdapter(rawString: trimmedString) {
            
            for each in csv.namedRows {
                
                let dateString = each["Date"] ?? ""
                let tradeVolume = each["Trade Volume"] ?? ""
                let tradeValue = each["Trade Value"] ?? ""
                let transaction = each["Transaction"] ?? ""
                let taiex = each["TAIEX"] ?? ""
                let change = each["Change"] ?? ""
                
                if let date = dateUtility.getDate(from: dateString, format: "yyyy/MM/dd") {
                    // 這一份資料的最後面有 remarks 欄位，所以我們只拿轉得成 date 的資料
                    let info = TwMarketTradingInfo(
                        date: date,
                        tradeVolumeString: tradeVolume,
                        tradeValueString: tradeValue,
                        transactionString: transaction,
                        taiexString: taiex,
                        changeString: change)
                    dataSet.append(info)
                }
            }
        }
        
        return dataSet
    }
    
    private func trimmedFirstLine(_ string: String) -> String {
        
        return CSVAdapter.removeLine(string, at: 1)
    }
}
