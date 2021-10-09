//
//  MajorInvestorsDashboardViewController.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/16.
//

import UIKit
import Charts

class MajorInvestorsDashboardViewController: UIViewController {

    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var calculateLabel: UILabel!
    @IBOutlet weak var totalPieChartContainer: UIView!
    
    @IBOutlet weak var detailPieChartContainer: UIView!
    
    private lazy var detailPieChartView: PieChartView = {
        let view = PieChartView()
        return view
    }()
    
    private lazy var totalPieChartView: PieChartView = {
        let view = PieChartView()
        return view
    }()
    
    var majorInvestors = [MajorInvestor]()
    
    var dailyTradingInfo = [TwMarketTradingInfo]()
    
    var date = Date()
    
    private var totalMajorInvestorInfo: TotalMajorInvestorInfo?
    
    private lazy var dateUtility: DateUtility = {
        return DateUtility()
    }()
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addPieChart()
    }
    
    // MARK: ui methods
    private func setup(chartView: PieChartView) {
        
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        chartView.drawHoleEnabled = false
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        chartView.entryLabelColor = .darkText
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        l.textColor = .black
        //        chartView.legend = l
    }
    
    private func setupUI() {
        
        let stateText = dateUtility.getString(date: date, format: "yyyy年MM月dd日")
        stateLabel.text = "\(stateText) 三大法人資訊"
        
        detailPieChartContainer.backgroundColor = .clear
        totalPieChartContainer.backgroundColor = .clear
    }
    
    private func updateCalculateUI() {
        
        var text = "計算完畢  "
        
        let unit = 100_000_000 //億
        
        if let total = totalMajorInvestorInfo?.total {
            
            let item = total.getItemName()
            
            let buy = Int(total.totalBuy) / unit
            
            let sell = Int(total.totalSell) / unit
            
            let diff = Int(total.difference) / unit
            
            text += " \(item): - 買進:\(buy) 億, 賣出:\(sell) 億, 買賣差:\(diff) 億,"
        }
        
        calculateLabel.text = text
    }
    
    private func addPieChart() {
        
        totalPieChartContainer.addSubview(totalPieChartView)
        totalPieChartView.translatesAutoresizingMaskIntoConstraints = false
        totalPieChartView.leadingAnchor.constraint(equalTo: totalPieChartContainer.leadingAnchor).isActive = true
        totalPieChartView.trailingAnchor.constraint(equalTo: totalPieChartContainer.trailingAnchor).isActive = true
        totalPieChartView.topAnchor.constraint(equalTo: totalPieChartContainer.topAnchor).isActive = true
        totalPieChartView.bottomAnchor.constraint(equalTo: totalPieChartContainer.bottomAnchor).isActive = true
        
        detailPieChartContainer.addSubview(detailPieChartView)
        detailPieChartView.translatesAutoresizingMaskIntoConstraints = false
        detailPieChartView.leadingAnchor.constraint(equalTo: detailPieChartContainer.leadingAnchor).isActive = true
        detailPieChartView.trailingAnchor.constraint(equalTo: detailPieChartContainer.trailingAnchor).isActive = true
        detailPieChartView.topAnchor.constraint(equalTo: detailPieChartContainer.topAnchor).isActive = true
        detailPieChartView.bottomAnchor.constraint(equalTo: detailPieChartContainer.bottomAnchor).isActive = true
    }
    
    /// 計算三大法人各組成佔總股市交易的額度
    private func updateDetailPieChartThreeMajorPercentage(chartView: PieChartView) {
        
        guard let twMarketTradingInfo = getMarketTradingInfo(),
              let dealers = totalMajorInvestorInfo?.dealers,
              let securities = totalMajorInvestorInfo?.securitiesInvestorForTrust,
              let foreign = totalMajorInvestorInfo?.foreign,
              let total = totalMajorInvestorInfo?.total else {
            print("找不到和三大法人同日的大盤成交資訊，請檢查資料來源")
            return
        }
        
        let dealersTrading = dealers.totalBuy + dealers.totalSell
        let securitiesTrading = securities.totalBuy + securities.totalSell
        let foreignTrading = foreign.totalBuy + foreign.totalSell
        let totalTrading = total.totalBuy + total.totalSell
        let twMarketTrading = twMarketTradingInfo.value ?? 0
        
        let data = getPieChartData(dealersTrading: dealersTrading, securitiesTrading: securitiesTrading, foreignTrading: foreignTrading, totalTrading: totalTrading, twMarketTrading: twMarketTrading)
        chartView.data = data
    }
    
    private func getPieChartData(dealersTrading: Double, securitiesTrading: Double, foreignTrading: Double, totalTrading: Double, twMarketTrading: Double) -> PieChartData {
        
        let threeMajorPercentage = (totalTrading / twMarketTrading) / 2
        let nonMajorPercentage = 1 - threeMajorPercentage
        
        let threeMajorPartial = dealersTrading + securitiesTrading + foreignTrading
        
        let dealersPercentage = dealersTrading * threeMajorPercentage / threeMajorPartial
        let securitiesPercentage = securitiesTrading * threeMajorPercentage / threeMajorPartial
        let foreignPercentage = foreignTrading * threeMajorPercentage / threeMajorPartial
        
        let dealersDataEntry = PieChartDataEntry(value: dealersPercentage, label: "自營商")
        let securitiesDataEntry = PieChartDataEntry(value: securitiesPercentage, label: "投信")
        let foreignDataEntry = PieChartDataEntry(value: foreignPercentage, label: "外資")
        let nonMajorDataEntry = PieChartDataEntry(value: nonMajorPercentage, label: "非三大法人")
        
        let dataSet = PieChartDataSet(entries: [foreignDataEntry, dealersDataEntry, securitiesDataEntry, nonMajorDataEntry])
        dataSet.colors = [.systemRed, .systemGreen, .systemGray, .systemBlue]
        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(.darkText)
        return data
    }
    
    /// 計算三大法人佔總股市交易的額度
    private func updatePieChartThreeMajorPercentage(chartView: PieChartView) {
        
        guard let twMarketTradingInfo = getMarketTradingInfo(),
              let threeMajor = totalMajorInvestorInfo?.total else {
            print("找不到和三大法人同日的大盤成交資訊，請檢查資料來源")
            return
        }
        
        let threeMajorTrading = threeMajor.totalBuy + threeMajor.totalSell
        let twMarketTrading = twMarketTradingInfo.value ?? 0

        let data = getPieChartData(threeMajorTrading: threeMajorTrading, twMarketTrading: twMarketTrading)
        
        chartView.data = data
    }
    
    // MARK: logci methods
    
    private func getPieChartData(threeMajorTrading: Double, twMarketTrading: Double) -> PieChartData {
        
        let threeMajorPercentage = (threeMajorTrading / twMarketTrading) / 2
        let nonThreeMajorPercentage = 1 - threeMajorPercentage
        
        let threeMajorTradingData = PieChartDataEntry(value: threeMajorPercentage, label: "三大法人交易額")
        let nonThreeMajorTradingData = PieChartDataEntry(value: nonThreeMajorPercentage, label: "非三大法人交易額")
        
        let dataSet = PieChartDataSet(entries: [threeMajorTradingData, nonThreeMajorTradingData])
        dataSet.colors = [.systemGreen, .systemBlue]
        let data = PieChartData(dataSet: dataSet)
        data.setValueTextColor(.darkText)
        return data
    }
    
    /// 獲得當下三大法人日期的大盤資訊
    private func getMarketTradingInfo() -> TwMarketTradingInfo? {
        
        let timeInterval = date.timeIntervalSince1970
        
        for info in dailyTradingInfo {
            
            if info.date.timeIntervalSince1970 == timeInterval {
                return info
            }
        }
        return nil
    }
    
    /// 取得三大法人 自營商的總和項目
    private func getDealerInfo(detailMajorInfos: [MajorInvestor]) -> ThreeMajorInvestorInfo {
        
        let info = ThreeMajorInvestorInfo(type: .dealers)
        
        for each in detailMajorInfos {
            
            // Dealer 自營商有兩項 1.自行買賣 2.避險
            if each.typeString.contains("Dealer") {
                
                info.totalBuy += each.totalBuy
                info.totalSell += each.totalSell
                info.difference += each.difference
            }
        }
        
        return info
    }
    
    /// 取得三大法人 投信的總和項目
    private func getSecuritiesTrustCompany(detailMajorInfos: [MajorInvestor]) -> ThreeMajorInvestorInfo {
        
        let info = ThreeMajorInvestorInfo(type: .securitiesInvestorForTrust)
        
        for each in detailMajorInfos {
            
            // 投信
            if each.typeString.contains("Securities") {
                
                info.totalBuy += each.totalBuy
                info.totalSell += each.totalSell
                info.difference += each.difference
            }
        }
        
        return info
    }
    
    private func getForeignInvestor(detailMajorInfos: [MajorInvestor]) -> ThreeMajorInvestorInfo {
        
        let info = ThreeMajorInvestorInfo(type: .foreign)
        
        for each in detailMajorInfos {
            
            // 外資
            if each.typeString.contains("Foreign") {
                
                info.totalBuy += each.totalBuy
                info.totalSell += each.totalSell
                info.difference += each.difference
            }
        }
        
        return info
    }
    
    /// 取得三大法人 total 的項目
    private func getTotalInfo(detailMajorInfos: [MajorInvestor]) -> ThreeMajorInvestorInfo {
        
        let info = ThreeMajorInvestorInfo(type: .total)
        
        for each in detailMajorInfos {
            if each.typeString.contains("Total") {
                
                info.totalBuy = each.totalBuy
                info.totalSell = each.totalSell
                info.difference = each.difference
            }
        }
        
        return info
    }
    
    /// 這邊有可優化空間
    private func calculate(detailMajorInfos: [MajorInvestor]) -> TotalMajorInvestorInfo {
        
        let dealer = getDealerInfo(detailMajorInfos: detailMajorInfos)
        let securitiesTrustCompany = getSecuritiesTrustCompany(detailMajorInfos: detailMajorInfos)
        let foreign = getForeignInvestor(detailMajorInfos: detailMajorInfos)
        let total = getTotalInfo(detailMajorInfos: detailMajorInfos)
        
        let threeMajor = TotalMajorInvestorInfo(dealers: dealer, securitiesInvestorForTrust: securitiesTrustCompany, foreign: foreign, total: total)
        
        return threeMajor
    }
    
    // MARK: - IBAction
    @IBAction func calculateButtonDidTap(_ sender: Any) {
        
        let threeMajorInvestors = calculate(detailMajorInfos: self.majorInvestors)
        self.totalMajorInvestorInfo = threeMajorInvestors
        
        updateCalculateUI()
    }
    
    @IBAction func drawPieChartButtonDidTap(_ sender: Any) {
        setup(chartView: self.detailPieChartView)
        setup(chartView: self.totalPieChartView)
        updateDetailPieChartThreeMajorPercentage(chartView: self.detailPieChartView)
        updatePieChartThreeMajorPercentage(chartView: self.totalPieChartView)
    }
}
