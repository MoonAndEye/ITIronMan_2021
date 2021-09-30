//
//  DateUtility.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/5.
//

import Foundation

struct DateUtility {
    
    static let dateFormatter = DateFormatter()
    
    private var isoCalendar: Calendar {
        return Calendar(identifier: .iso8601)
    }
    
    private var rocCalendar: Calendar {
        return Calendar(identifier: .republicOfChina)
    }
    
    func getDate(from string: String, format: String = "yyyy-MM-dd") -> Date? {
        
        DateUtility.dateFormatter.calendar = isoCalendar
        DateUtility.dateFormatter.dateFormat = format
        
        return DateUtility.dateFormatter.date(from: string)
    }
    
    func getDateFromTwCalendar(from string: String, format: String = "yyyy/MM/dd") -> Date? {
        
        DateUtility.dateFormatter.calendar = rocCalendar
        DateUtility.dateFormatter.dateFormat = format
        
        return DateUtility.dateFormatter.date(from: string)
    }
    
    func getIntFromDate(component: Calendar.Component) -> Int {
        
        let date = Date()
        let calendar = isoCalendar
        return calendar.component(component, from: date)
    }
    
    func getString(date: Date, format: String = "yyyy-MM-dd") -> String {
        
        DateUtility.dateFormatter.calendar = isoCalendar
        DateUtility.dateFormatter.dateFormat = format
        
        return DateUtility.dateFormatter.string(from: date)
    }
    
    func getStartOfMonth(date: Date = Date()) -> Date {
        
        let calendar = isoCalendar
        let startDate = isoCalendar.startOfDay(for: date)
        return calendar.date(from: calendar.dateComponents([.year, .month], from: startDate)) ?? Date()
    }
    
    func getLastMonthStartDate(date: Date = Date()) -> Date {
        
        let calendar = isoCalendar
        let startOfMonth = getStartOfMonth(date: date)
        
        return calendar.date(byAdding: DateComponents(month: -1), to: startOfMonth) ?? Date()
    }
    
    func getMonthStartDate(date: Date = Date(), add month: Int) -> Date {
        
        let calendar = isoCalendar
        let startOfMonth = getStartOfMonth(date: date)
        
        return calendar.date(byAdding: DateComponents(month: month), to: startOfMonth) ?? Date()
    }
}

