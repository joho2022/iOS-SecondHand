//
//  Date+Extensions.swift
//  secondhand
//
//  Created by 조호근 on 6/11/24.
//

import Foundation

extension Date {
    var iso8601: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: self)
    }
    
    static private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter
    }()
    
    static func dateFromString(_ dateString: String) -> Date? {
        return formatter.date(from: dateString)
    }
    
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: self, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)일 전"
        }
        
        if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        }
        
        if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        }
        
        return "방금 전"
    }
}
