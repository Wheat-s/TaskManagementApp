//
//  Date.swift
//  TaskManagementApp
//
//  Created by wheat on 7/10/25.
//

import SwiftUI

import SwiftUI

extension Date {
    /// 获取当前周的 7 天日期（从周一或周日开始，取决于系统设置）
    static var currentWeek: [Day] {
        // 使用以周一为第一天的日历（中国习惯）
        let calendar = Calendar.current
 
        // 获取本周的起始日期（周日或周一，取决于系统）
        // 获取本周的范围（从周一开始）
        guard let firstWeekDay = calendar.dateInterval(of: .weekOfMonth, for: .now)?.start else {
            return []
        }

        var week: [Day] = [] // 一周日期

        // 从本周第一天开始，依次加 0~6 天，生成整周日期
        for index in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: index, to: firstWeekDay) {
                week.append(.init(date: day))
            }
        }

        return week
    }
    
    /// 将日期转换为字符串（支持自定义格式）
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// 判断两个日期是否是同一天（只比较年月日）
    func isSame(date: Date?) -> Bool {
        guard let date else {
            return false
        }
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    struct Day: Identifiable {
        var id: String = UUID().uuidString
        var date: Date
        /// Other additional Properties as per your needs!
        
    }
}
