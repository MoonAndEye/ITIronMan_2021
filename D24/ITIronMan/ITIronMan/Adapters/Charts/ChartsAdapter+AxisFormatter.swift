//
//  ChartsAdapter+AxisFormatter.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/10.
//

import UIKit
import Charts

extension ChartsAdapter {
    
    class CandleXAxisValueFormatter: IAxisValueFormatter {
        
        private let indexLabelMap: [Int: String]
        
        /// 因為 candle charts 是用 index 來當 x 軸，但是 index 需要 mapping 成 date string，才可以讓人類識別每個 candle stick 代表的意義
        /// - Parameter indexLabelMap: index vs. date string
        init(indexLabelMap: [Int: String]) {
            self.indexLabelMap = indexLabelMap
        }
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            
            guard let string = indexLabelMap[Int(value)] else {
                return ""
            }
            return string
        }
    }
}
