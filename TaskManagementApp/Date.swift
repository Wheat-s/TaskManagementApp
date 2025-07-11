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
    static var currentWeek: [Date] {
        // 使用以周一为第一天的日历（中国习惯）
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 周一 = 2，周日 = 1
        
        let now = Date()  // 当前日期
 
        // 获取本周的起始日期（周日或周一，取决于系统）
        // 获取本周的范围（从周一开始）
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: now),
              let firstWeekDay = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))
        else {
            return []
        }

        var week: [Date] = [] // 一周日期

        // 从本周第一天开始，依次加 0~6 天，生成整周日期
        for index in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: index, to: firstWeekDay) {
                week.append(day)
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
}
