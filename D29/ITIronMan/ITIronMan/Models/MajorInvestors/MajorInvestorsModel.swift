//
//  MajorInvestorsModel.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/16.
//

import Foundation

protocol MajorInvestorsModelDelegate: AnyObject {
    func didRecieve(investors: [MajorInvestor], error: Error?)
    func didRecieve(dailyTradingInfo: [TwMarketTradingInfo], error: Error?)
}

class MajorInvestorsModel {
    
    weak var delegate: MajorInvestorsModelDelegate?
    
    var majorInvestors = [MajorInvestor]()
    
    var dailyTradingInfo = [TwMarketTradingInfo]()
    
    private lazy var threeMajorManager: ThreeMajorInvestorsManager = {
        let manager = ThreeMajorInvestorsManager()
        return manager
    }()
    
    private lazy var marketManager: TwMarketTradingInfoManager = {
        let manager = TwMarketTradingInfoManager()
        return manager
    }()
    
    func getDate() -> Date {
        
        var date = Date()
        
        for investor in majorInvestors {
            
            date = investor.date
        }
        return date
    }
    
    func requestMajorInvestorsAndTwMarket() {
        threeMajorManager.requestInvestorsInfo { [weak self] investors, error in
            self?.majorInvestors = investors
            self?.delegate?.didRecieve(investors: investors, error: error)
        }
        
        marketManager.requestTwMarketDailyTradingInfo(date: Date()) { [weak self] dailyTradingInfo, error in
            self?.dailyTradingInfo = dailyTradingInfo
            self?.delegate?.didRecieve(dailyTradingInfo: dailyTradingInfo, error: error)
        }
    }
}

