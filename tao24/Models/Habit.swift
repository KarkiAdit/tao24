//
//  Habit.swift
//  tao24
//
//  Created by Aditya Karki on 4/9/26.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var title: String
    var scheduledType: HabitScheduleType
    /*
     Used when scheduleType is .custom.
     Each bit represents a day with Sunday masked with 2^0 and Saturday masked with 2^6.
    */
    var customDaysBitmask: Int16?
    var reminderEnabled: Bool
    var reminderTime: Date?
    let createdAt: Date
    var isArchived: Bool
    
    enum HabitScheduleType: String, Codable, CaseIterable {
        case daily
        case weekdays
        case weekends
        case custom
    }
}


// MARK: - Helpers
extension Habit {
    /*
     This property transforms the messy bitmask into a clean list for the UI.
     It iterates through 7 bits and checks if each is "on" (1) or "off" (0).
     */
    var activeDays: [Int] {
        var days: [Int] = []
        for i in 0..<7 {
            if (customDaysBitmask ?? 0) & (1 << (Int16(i))) != 0 {
                days.append(i)
            }
        }
        return days
    }
}
