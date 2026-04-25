//
//  Habit.swift
//  tao24
//
//  Created by Aditya Karki on 4/9/26.
//

import Foundation

struct Habit: Identifiable, Codable {
    
    // MARK: - Identity & Metadata
    
    let id: UUID
    var title: String
    let createdAt: Date

    /*
     Soft-delete flag — hides from active views while preserving historical data.
     Lets users "retire" seasonal goals without losing their record of achievement.
    */
    var isArchived: Bool
    
    // MARK: - Scheduling & Reminders
    
    var scheduledType: HabitScheduleType

    /*
     Day-of-week bitmask (Sun = bit 0, Sat = bit 6).
     Only used when `scheduledType == .custom`.
    */
    var customDaysBitmask: Int16?

    var reminderEnabled: Bool
    var reminderTime: Date?
    
    // MARK: - Visual Identity
    
    /*
     SF Symbol name (e.g. "figure.run", "leaf.fill") for visual recognition.
     Enables pre-attentive processing — users identify the habit at a glance
     without reading text, reducing cognitive load.
    */
    var iconName: String?
    
    // MARK: - Behavioral Design
    
    /*
     Environmental cue that triggers the habit (where/when).
     Based on "Implementation Intentions" — bridging intent and action.
     e.g. "At my desk", "When I sit on the sofa."
    */
    var context: String?

    /*
     Existing routine this habit anchors to (B.J. Fogg’s "Habit Stacking").
     Removes reliance on willpower by chaining to an established behavior.
     e.g. "After I pour my morning coffee."
    */
    var anchorHabit: String?

    /*
     "Too-small-to-fail" version for low-motivation days.
     Lowers activation energy — keeps the streak alive even on bad days.
     e.g. "Read 1 page" instead of a full chapter.
    */
    var minimumViableAction: String?

    /*
     Intermediate target the user is working toward.
     "Small wins" sustain motivation by making long-term progress tangible.
    */
    var currentMilestone: String?

    /*
     Ultimate vision of success — the "Ideal Self" version.
     Acts as a North Star for long-term direction and aspirational purpose.
    */
    var northStarGoal: String?

    /*
     Intrinsic "Why" behind the habit (Self-Determination Theory).
     Aligning with core values shifts motivation from "have to" to "want to."
    */
    var purposeStatement: String?

    /*
     Personal reflections or metacognitive notes on performance and mindset.
    */
    var notes: String?
    
    // MARK: - Enums
    
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
     Converts the bitmask into an array of active day indices (0–6) for the UI.
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
