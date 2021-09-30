//
//  ITIronManTests.swift
//  ITIronManTests
//
//  Created by Marvin on 2021/9/2.
//

import XCTest
@testable import ITIronMan

class ITIronManTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_numberFormat() {
        
        let string = "123,456.789"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "tw")
        let number = numberFormatter.number(from: string)
        print(number)
    }
    
    func test_array() {
        
        let maPeriod = 5
        let tickIndices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        
        for (i, index) in tickIndices.enumerated() {
            
            let needCalculateTicks = tickIndices.suffix(from: i).prefix(maPeriod)
            if needCalculateTicks.count < maPeriod {
                break
            }
            
            print(needCalculateTicks)
        }
        
    }
}
