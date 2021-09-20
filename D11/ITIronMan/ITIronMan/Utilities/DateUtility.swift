//
//  DateUtility.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/5.
//

import Foundation

struct DateUtility {
    
    static let dateFormatter = DateFormatter()
    
    func getIntFromDate(component: Calendar.Component) -> Int {
        
        let date = Date()
        let calendar = getISOCalendar()
        return calendar.component(component, from: date)
    }
    
    func getDate(from string: String, format: String = "yyyy-MM-dd") -> Date? {
        
        DateUtility.dateFormatter.calendar = getISOCalendar()
        DateUtility.dateFormatter.dateFormat = format
        
        return DateUtility.dateFormatter.date(from: string)
    }
    
    func getDateFromTwCalendar(from string: String, format: String = "yyyy/MM/dd") -> Date? {
        
        DateUtility.dateFormatter.calendar = getROCCalendar()
        DateUtility.dateFormatter.dateFormat = format
        
        return DateUtility.dateFormatter.date(from: string)
    }
    
    private func getISOCalendar() -> Calendar {
        return Calendar(identifier: .iso8601)
    }
    
    private func getROCCalendar() -> Calendar {
        return Calendar(identifier: .republicOfChina)
    }
}
