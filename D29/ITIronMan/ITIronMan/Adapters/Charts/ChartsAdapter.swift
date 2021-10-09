//
//  ChartsAdapter.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/7.
//

import UIKit
import Charts

class ChartsAdapter {
}

// MARK: - 這一段的程式碼做 K Line charts
extension ChartsAdapter {
    
    /// 讓 VC 在需要 K Line 圖的時候直接拿到一個 K Line View，但為了不讓外部看到 Charts，回傳 UIView
    /// - Returns: 因 CandleStickChartView 繼承 UIView，封裝起來，不讓外部看到 Charts
    func getCandleStickChartView() -> UIView {
        
        let candleView = CandleStickChartView()
        setupCandleStickView(candleView)
        return candleView
    }
    
    func update(stockSticks: [StockKLine], on candleView: UIView) {
        
        if let candleView = candleView as? CandleStickChartView {
            let dataEntry = convert(stockStick: stockSticks)
            let dataSet = convert(dataEntry: dataEntry)
            let data = convert(dataSet: dataSet)
            candleView.data = data
            
            let indexDateLabels = getIndexDateLabels(from: stockSticks)
            
            updateXAxis(candleView, indexDateLabels: indexDateLabels)
            updateMaxMin(candleView, dataSet: dataSet)
        }
    }
    
    private func getIndexDateLabels(from stockSticks: [StockKLine]) -> [Int: String] {
    
        let dateUtility = DateUtility()
        
        var indexDateLabels = [Int: String]()
        
        for (index, stick) in stockSticks.enumerated() {
            
            if let date = stick.date {
                let dateString = dateUtility.getString(date: date, format: "MM/dd")
                indexDateLabels[index] = dateString
            }
        }
        return indexDateLabels
    }
    
    private func updateXAxis(_ chartView: BarLineChartViewBase, indexDateLabels: [Int: String]) {
        
        chartView.xAxis.valueFormatter = CandleXAxisValueFormatter(indexLabelMap: indexDateLabels)
        chartView.xAxis.granularity = 1.0
    }
    
    private func setupCandleStickView(_ chartView: CandleStickChartView) {
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 200
        chartView.pinchZoomEnabled = true
        
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .vertical
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont.systemFont(ofSize: 10)
        
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        chartView.xAxis.labelCount = 10
    }
    
    private func convert(stockStick: [StockKLine]) -> [CandleChartDataEntry] {
        
        var dataEntry = [CandleChartDataEntry]()
        
        for (i, each) in stockStick.enumerated() {
            
            let x = Double(i)
            if let open = each.open,
               let highest = each.highest,
               let lowest = each.lowest,
               let close = each.close {
                
                let candleData = CandleChartDataEntry(x: x, shadowH: highest, shadowL: lowest, open: open, close: close)
                dataEntry.append(candleData)
            }
        }
        
        return dataEntry
    }
    
    private func convert(dataEntry: [CandleChartDataEntry]) -> CandleChartDataSet {
        
        let dataSet = CandleChartDataSet(entries: dataEntry, label: "K 線")
        
        dataSet.axisDependency = .left
        dataSet.setColor(.red)
        dataSet.drawIconsEnabled = false
        dataSet.shadowColor = .darkGray
        dataSet.shadowWidth = 0.5
        dataSet.decreasingColor = .systemGreen
        dataSet.decreasingFilled = true
        dataSet.increasingColor = .systemRed
        dataSet.increasingFilled = true
        dataSet.neutralColor = .black
        
        dataSet.drawValuesEnabled = false
        
        return dataSet
    }
    
    private func convert(dataSet: CandleChartDataSet) -> CandleChartData {
        
        return CandleChartData(dataSet: dataSet)
    }
    
    private func updateMaxMin(_ chartView: BarLineChartViewBase, dataSet: CandleChartDataSet) {
        
        let max = dataSet.yMax
        let min = dataSet.yMin
        chartView.leftAxis.axisMaximum = max * 1.03
        chartView.leftAxis.axisMinimum = min * 0.92
    }
    
    private func updateVolumeMaxMin(_ chartView: BarLineChartViewBase, dataSet: BarChartDataSet) {
        
        let max = dataSet.yMax
        chartView.rightAxis.axisMaximum = max * 10
    }
}

// MARK: - Combine Charts 相關 func
extension ChartsAdapter {
    
    private var maUtiltiy: MovingAverageUtility {
        return MovingAverageUtility()
    }
    
    func getCombineChartView() -> UIView {
        let view = CombinedChartView()
        setupCombinedChartView(view)
        return view
    }
    
    func updateWithMALine(stockSticks: [StockKLine], volumeDataList: [TwMarketTradingInfo], combinedView: UIView) {
        
        if let combinedView = combinedView as? CombinedChartView {
            
            let ma5DataSet = getMALineData(stockSticks: stockSticks, range: 5, color: .blue)
            let ma10DataSet = getMALineData(stockSticks: stockSticks, range: 10, color: .red)
            let ma20DataSet = getMALineData(stockSticks: stockSticks, range: 20, color: .systemOrange)
            
            let lineData = LineChartData(dataSets: [ma5DataSet, ma10DataSet, ma20DataSet])
            let candleData = getCandleData(stockSticks: stockSticks)
            let barData = getVolumeBarData(volumeDataList: volumeDataList)
            
            let combinedData = CombinedChartData()
            combinedData.lineData = lineData
            combinedData.candleData = candleData
            combinedData.barData = barData
            
            combinedView.data = combinedData
            
            // 這邊有優化空間，請讀者自行優化
            let candleDataEntry = convert(stockStick: stockSticks)
            let dataSet = convert(dataEntry: candleDataEntry)
            updateMaxMin(combinedView, dataSet: dataSet)
            
            // 調整右方 y 軸
            if let barDataSet = barData.dataSets.first as? BarChartDataSet {
                updateVolumeMaxMin(combinedView, dataSet: barDataSet)
            }
            
            let indexDateLabels = getIndexDateLabels(from: stockSticks)
            updateXAxis(combinedView, indexDateLabels: indexDateLabels)
        }
    }
    
    /// 取得大盤量的 Data
    private func getVolumeBarData(volumeDataList: [TwMarketTradingInfo]) -> BarChartData {
        
        var barDataEntryList = [BarChartDataEntry]()
        
        for (index, info) in volumeDataList.enumerated() {
            
            let y = info.volume ?? 0
            let dataEntry = BarChartDataEntry(x: Double(index), y: y)
            barDataEntryList.append(dataEntry)
        }
        
        let dataSet = BarChartDataSet(entries: barDataEntryList)
        dataSet.drawValuesEnabled = false //如果把數值也列出，圖會非常的雜亂，而且值可以設定在右邊
        dataSet.axisDependency = .right //左方的軸已經設定給加權指數了，所以量的圖要設定在右邊的軸
        
        let colors = getBarColors(volumeList: volumeDataList) //加上顏色
        dataSet.colors = colors
        
        let data = BarChartData(dataSet: dataSet)
        return data
    }
    
    private func getBarColors(volumeList: [TwMarketTradingInfo]) -> [UIColor] {
    
        let colors = volumeList.map { info -> UIColor in
            
            let change = info.change ?? 0
            if change < 0 {
                return UIColor.systemGreen
            }
            return UIColor.systemRed
        }
        return colors
    }

    private func getMALineData(stockSticks: [StockKLine], range: Int, color: UIColor) -> LineChartDataSet {
        
        var lineDataEntry = [ChartDataEntry]()
        
        let maPoints = maUtiltiy.getMAPoints(from: stockSticks, range: range)
        
        for point in maPoints {
            let dataEntry = ChartDataEntry(x: point.x, y: point.y)
            lineDataEntry.append(dataEntry)
        }
        
        // maPoints 得到了
        let maDataSet = LineChartDataSet(entries: lineDataEntry, label: "\(range) MA")
        maDataSet.setColor(color)
        maDataSet.lineWidth = 1
        maDataSet.drawCirclesEnabled = false
        maDataSet.drawValuesEnabled = false
        maDataSet.axisDependency = .left
        maDataSet.highlightEnabled = true
        
        return maDataSet
    }
    
    private func getCandleData(stockSticks: [StockKLine]) -> CandleChartData {
        
        let candleDataEntry = convert(stockStick: stockSticks)
        let candleDataSet = convert(dataEntry: candleDataEntry)
        let candleData = convert(dataSet: candleDataSet)
        return candleData
    }
    
    private func setupCombinedChartView(_ chartView: CombinedChartView) {
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 1000
        chartView.pinchZoomEnabled = true
        
        chartView.legend.enabled = false //關掉這個，右上方的 legend 的空間就會被釋放出來
        
        chartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 10)
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        chartView.xAxis.labelCount = 10
    }
}
