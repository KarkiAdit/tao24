//
//  HabitStore.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import Foundation

final class HabitStore {
    private let fileName = "habits.json"

    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    private var fileURL: URL {
        documentsDirectory.appendingPathComponent(fileName)
    }
    
    // MARK: - CRUD Operations
    func save(_ habits: [Habit]) {
        do {
            let encoder = JSONEncoder()
            // Makes the JSON human-readable
            encoder.outputFormatting = .prettyPrinted

            let data = try encoder.encode(habits)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            
            print("Successfully saved to: \(fileURL.lastPathComponent)")
        } catch {
            print("Failed to save habits: \(error.localizedDescription)")
        }
    }

    func load() -> [Habit] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let habits = try decoder.decode([Habit].self, from: data)
            return habits
        } catch {
            print("Failed to load habits: \(error.localizedDescription)")
            return []
        }
    }
}

