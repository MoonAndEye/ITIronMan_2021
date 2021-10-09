//
//  StockInfoManager.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/3.
//

import Foundation

/// 這一個類別主要處理上市上櫃興興公司相關資料
class StockInfoManager {
    
    private lazy var alamofireAdapter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()
    
    /// 取得上市公司基本資料
    func requestTwStockCodeAndName(completion: @escaping (([StockBasicInfo], Error?) -> Void)) {
        
        let urlString = "https://mopsfin.twse.com.tw/opendata/t187ap03_L.csv"
        
        requestStockInfoBasic(urlString) { list, error in
            completion(list, error)
        }
    }
    
    /// 取得上櫃公司基本資料
    func requestOTCCodeAndName(completion: @escaping (([StockBasicInfo], Error?) -> Void)) {
        
        let urlString = "https://mopsfin.twse.com.tw/opendata/t187ap03_O.csv"
        
        requestStockInfoBasic(urlString) { list, error in
            completion(list, error)
        }
    }
    
    /// 取得興櫃公司基本資料
    func requestEmerginCodeAndName(completion: @escaping (([StockBasicInfo], Error?) -> Void)) {
        
        let urlString = "https://mopsfin.twse.com.tw/opendata/t187ap03_R.csv"
        
        requestStockInfoBasic(urlString) { list, error in
            completion(list, error)
        }
    }
    
    private func requestStockInfoBasic(_ urlString: String, completion: @escaping ([StockBasicInfo], Error?) -> Void) {
        
        var companyList = [StockBasicInfo]()
        
        alamofireAdapter.request(urlString, method: .get) { data, response, error in
            
            if let error = error {
                print("tw stock fetch error: \(error.localizedDescription)")
                completion(companyList, error)
                return
            }
            
            if let data = data,
               let string = String(data: data, encoding: .utf8),
               let csv = CSVAdapter(rawString: string) {
                
                for company in csv.namedRows {
                    
                    let stockCode = company["公司代號"] ?? ""
                    let stockName = company["公司簡稱"] ?? ""
                    let companyName = company["公司名稱"] ?? ""
                    let capital = company["實收資本額"] ?? ""
                    
                    let info = StockBasicInfo(stockCode: stockCode, stockName: stockName, companyName: companyName, capital: capital)
                    companyList.append(info)
                }
            }
            
            completion(companyList, nil)
        }
    }
}
