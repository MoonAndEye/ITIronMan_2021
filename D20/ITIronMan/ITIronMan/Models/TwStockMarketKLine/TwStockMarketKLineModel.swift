//
//  TwStockMarketKLineModel.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/7.
//

import Foundation

protocol TwStockMarketKLineModelDelegate: AnyObject {
    
    func didRecieveTaiEx(kLineDataSet: [StockKLine], error: Error?)
}

class TwStockMarketKLineModel {
    
    weak var delegate: TwStockMarketKLineModelDelegate?
    
    private var dateUtility: DateUtility {
        return DateUtility()
    }
    
    private lazy var manager: TwStockKLineManager = {
        return TwStockKLineManager()
    }()
    
    var twExStockDataSet = [StockKLine]()
    
    /// 會取這個月和前一個月台股加權指的 KLine data，單一個月，有可能 k 棒數量太少
    func requestTwExKLineInfo() {
        
        requestTwExThisMonthKLineInfo()
        requestTwExLastMonthKLineInfo()
        requestTwExBefore2MonthKLineInfo()
    }
    
    /// 拿當月的 k line
    private func requestTwExThisMonthKLineInfo() {
        
        let date = dateUtility.getStartOfMonth()
        manager.requestTwStockKLine(date: date) { [weak self] kLineDataSet, error in
            
            self?.update(kLineDataSet)
            self?.delegate?.didRecieveTaiEx(kLineDataSet: kLineDataSet, error: error)
        }
    }
    
    /// 拿前一個月的 k line
    private func requestTwExLastMonthKLineInfo() {
        
        let date = dateUtility.getLastMonthStartDate()
        manager.requestTwStockKLine(date: date) { [weak self] kLineDataSet, error in
            
            self?.update(kLineDataSet)
            self?.delegate?.didRecieveTaiEx(kLineDataSet: kLineDataSet, error: error)
        }
    }
    
    /// 拿前兩個月的 k line
    private func requestTwExBefore2MonthKLineInfo() {
        
        let date = dateUtility.getMonthStartDate(date: Date(), add: -2)
        manager.requestTwStockKLine(date: date) { [weak self] kLineDataSet, error in
            
            self?.update(kLineDataSet)
            self?.delegate?.didRecieveTaiEx(kLineDataSet: kLineDataSet, error: error)
        }
    }
    
    private func update(_ dataSet: [StockKLine]) {
        
        let updatedData = Set(self.twExStockDataSet + dataSet)
        self.twExStockDataSet = Array(updatedData).sorted { $0.dateString < $1.dateString }
    }
}
