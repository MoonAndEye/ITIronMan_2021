//
//  MovingAverageUtility.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/10.
//

import Foundation

/// 專門處理移動平均線的物件
struct MovingAverageUtility {
    
    /// 將已得到的 K 棒，轉出 5 MA 的資料
    /// - Parameter stockTicks: 傳入的 K 棒需先保證 date 從遠排到近
    /// - Returns: 回傳的 MA 點也保證會是 x 從小排到大
    func getMAPoints(from stockTicks: [StockKLine], range: Int) -> [MovingAveragePoint] {
        
        let maPeriod = range
        
        let tickIndices = Array(stockTicks.indices).sorted { $0 > $1 } // 先拿出 index 並把 index 從大到小排
        
        var maPoints = [MovingAveragePoint]()
        
        for tickIndex in tickIndices {

            let startIndex = tickIndex - maPeriod + 1
            
            if !stockTicks.indices.contains(startIndex) || !stockTicks.indices.contains(tickIndex) {
                break
            }
            
            let needCalculateTicks = Array(stockTicks[startIndex...tickIndex])
            
            // 從這裡開始計算 n 日內收盤價的平均，有更有效率的做法，像是動態規畫的方式實作。這一段就留給讀者自行優化
            let closePriceList = needCalculateTicks.map { tick in
                
                return tick.close ?? 0 // 這邊先不考慮如果沒有收盤價(暫停交易)的情況，如果有，應該把這個點去除掉，使用 filter 即可
            }
            
            let sum = closePriceList.reduce(0, +) //總合
            let maValue = sum / Double(maPeriod)
            
            let point = MovingAveragePoint(x: Double(tickIndex), y: maValue)
            maPoints.append(point)
        }
        
        return maPoints.sorted { $0.x < $1.x }
    }
}
