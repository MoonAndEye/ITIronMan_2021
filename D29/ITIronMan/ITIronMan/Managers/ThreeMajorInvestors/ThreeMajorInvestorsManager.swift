//
//  ThreeMajorTraderManager.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/15.
//

import Foundation

//三大法人
//https://www.twse.com.tw/zh/page/trading/fund/BFI82U.html
//https://www.twse.com.tw/en/fund/BFI82U?response=csv&dayDate=&weekDate=&monthDate=&type=day
// 如果要 query 某個日期
//https://www.twse.com.tw/en/fund/BFI82U?response=csv&dayDate=20210914&weekDate=20210913&monthDate=20210915&type=day
class ThreeMajorInvestorsManager {
    
    private lazy var alamofireAdapter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()
    
    func requestInvestorsInfo(completion: @escaping (([MajorInvestor], Error?) -> Void)) {
        
        let urlString = "https://www.twse.com.tw/en/fund/BFI82U?response=csv&dayDate=&weekDate=&monthDate=&type=day"
        
        alamofireAdapter.requestForString(urlString, method: .get) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let string):
                
                let firstLine = self.getFirstLine(string)
                let dateString = self.getDateString(from: firstLine)
                let majorInvestors = self.convert(from: string, dateString: dateString)
                completion(majorInvestors, nil)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    private func trimmedFirstLine(_ string: String) -> String {
        
        return CSVAdapter.removeLine(string, at: 1)
    }
    
    private func getFirstLine(_ string: String) -> String {
        return CSVAdapter.getFirstLine(string).replacingOccurrences(of: "\"", with: "")
    }
    
    private func getDateString(from firstLine: String) -> String {
        let separatedString = firstLine.components(separatedBy: " ")
        return separatedString.first ?? ""
    }
    
    private func convert(from string: String, dateString: String) -> [MajorInvestor] {
        
        var majorInvestors = [MajorInvestor]()
        
        let trimmedString = self.trimmedFirstLine(string)
        let dateUtility = DateUtility()
        
        if let csv = CSVAdapter(rawString: trimmedString),
           let date = dateUtility.getDate(from: dateString, format: "yyyy/MM/dd") {
            
            for each in csv.namedRows {
                
                let item = each["Item"] ?? ""
                let totalBuy = each["Total Buy"] ?? ""
                let totalSell = each["Total Sell"] ?? ""
                let difference = each["Difference"] ?? ""
                
                // 這一份 csv 檔有 footer，如果 difference 沒有字，就是 footer
                if !difference.isEmpty {
                    let majorInvestor = MajorInvestor(typeString: item, date: date, totalBuyString: totalBuy, totalSellString: totalSell, diffString: difference)
                    majorInvestors.append(majorInvestor)
                }
            }
        }
        
        return majorInvestors
    }
}
