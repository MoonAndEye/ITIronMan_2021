//
//  TwStockMarketKLineModel.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/7.
//

import Foundation

protocol TwStockMarketKLineModelDelegate: AnyObject {
    
    func didRecieveTaiEx(kLineDataSet: [StockKLine], error: Error?)
    func didRecieveVolume(volumeDataSet: [TwMarketTradingInfo], error: Error?)
}

class TwStockMarketKLineModel {
    
    weak var delegate: TwStockMarketKLineModelDelegate?
    
    private var dateUtility: DateUtility {
        return DateUtility()
    }
    
    private lazy var kLineManager: TwStockKLineManager = {
        return TwStockKLineManager()
    }()
    
    private lazy var volumeManager: TwMarketTradingInfoManager = {
        return TwMarketTradingInfoManager()
    }()
    
    var twExStockDataSet = [StockKLine]()
    
    var twExVolumeDataSet = [TwMarketTradingInfo]()
    
    // MARK: - 給外部呼叫的 func
    /// 會取這個月和前一個月台股加權指的 KLine data，單一個月，有可能 k 棒數量太少
    func requestTwExKLineAndVolumeInfo() {
        
        requestTwExKLineInfo()
        requestTwVolumeInfo()
    }
    
    // MARK: - 拿大盤量
    private func requestTwVolumeInfo() {
        requestTwThisMonthVolumeInfo()
        requestTwLastMonthVolumeInfo()
        requestTwBefore2MonthVolumeInfo()
    }
    
    private func requestTwThisMonthVolumeInfo() {
        
        let date = dateUtility.getStartOfMonth()
        volumeManager.requestTwMarketDailyTradingInfo(date: date) { [weak self] volumeList, error in
            
            self?.update(volumeList: volumeList)
            self?.delegate?.didRecieveVolume(volumeDataSet: volumeList, error: error)
        }
    }
    
    private func requestTwLastMonthVolumeInfo() {
        
        let date = dateUtility.getLastMonthStartDate()
        volumeManager.requestTwMarketDailyTradingInfo(date: date) { [weak self] volumeList, error in
            self?.update(volumeList: volumeList)
            self?.delegate?.didRecieveVolume(volumeDataSet: volumeList, error: error)
        }
    }
    
    private func requestTwBefore2MonthVolumeInfo() {
        
        let date = dateUtility.getMonthStartDate(date: Date(), add: -2)
        volumeManager.requestTwMarketDailyTradingInfo(date: date) { [weak self] volumeList, error in
            self?.update(volumeList: volumeList)
            self?.delegate?.didRecieveVolume(volumeDataSet: volumeList, error: error)
        }
    }
    
    // MARK: - 拿大盤 K 線
    private func requestTwExKLineInfo() {
        requestTwExThisMonthKLineInfo()
        requestTwExLastMonthKLineInfo()
        requestTwExBefore2MonthKLineInfo()
    }
    
    /// 拿當月的 k line
    private func requestTwExThisMonthKLineInfo() {
        
        let date = dateUtility.getStartOfMonth()
        kLineManager.requestTwStockKLine(date: date) { [weak self] kLineDataSet, error in
            
            self?.update(kLines: kLineDataSet)
            self?.delegate?.didRecieveTaiEx(kLineDataSet: kLineDataSet, error: error)
        }
    }
    
    /// 拿前一個月的 k line
    private func requestTwExLastMonthKLineInfo() {
        
        let date = dateUtility.getLastMonthStartDate()
        kLineManager.requestTwStockKLine(date: date) { [weak self] kLineDataSet, error in
            
            self?.update(kLines: kLineDataSet)
            self?.delegate?.didRecieveTaiEx(kLineDataSet: kLineDataSet, error: error)
        }
    }
    
    /// 拿前兩個月的 k line
    private func requestTwExBefore2MonthKLineInfo() {
        
        let date = dateUtility.getMonthStartDate(date: Date(), add: -2)
        kLineManager.requestTwStockKLine(date: date) { [weak self] kLineDataSet, error in
            
            self?.update(kLines: kLineDataSet)
            self?.delegate?.didRecieveTaiEx(kLineDataSet: kLineDataSet, error: error)
        }
    }
    
    // MARK: - 拿完資料後的內部處理
    private func update(kLines: [StockKLine]) {
        
        let updatedData = Set(self.twExStockDataSet + kLines)
        self.twExStockDataSet = Array(updatedData).sorted { $0.dateString < $1.dateString }
    }
    
    private func update(volumeList: [TwMarketTradingInfo]) {
        
        let updatedData = Set(self.twExVolumeDataSet + volumeList)
        self.twExVolumeDataSet = Array(updatedData).sorted { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 }
    }
}
