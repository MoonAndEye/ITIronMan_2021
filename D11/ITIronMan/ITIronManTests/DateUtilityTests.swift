//
//  DateUtilityTests.swift
//  ITIronManTests
//
//  Created by cm0679 on 2021/9/5.
//

import XCTest

class DateUtilityTests: XCTestCase {
    
    var dateUtility: DateUtility!

    override func setUpWithError() throws {
        super.setUp()
        dateUtility = DateUtility()
    }

    override func tearDownWithError() throws {
        dateUtility = nil
        super.tearDown()
    }
    
    func test_getDateFromString() {
        
        let string1 = "2021-09-05"
        let date1 = dateUtility.getDate(from: string1)
        XCTAssertEqual(date1?.timeIntervalSince1970, 1630771200.0)
        
        let string2 = "110/09/05"
        let date2 = dateUtility.getDateFromTwCalendar(from: string2)
        XCTAssertEqual(date2?.timeIntervalSince1970, 1630771200.0)
    }
    
    func test_getDateComponentInt() {
        
        let year = dateUtility.getIntFromDate(component: .year)
        XCTAssertEqual(year, 2021)
        
        let month = dateUtility.getIntFromDate(component: .month)
        XCTAssertEqual(month, 9)
    }
}
