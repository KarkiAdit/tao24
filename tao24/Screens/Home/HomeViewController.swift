//
//  HomeViewController.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Persistence
    private let store = HabitStore()
    
    // MARK: - UI Components
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /* TEMPORARY UI: The following button is for testing the HabitStore logic.
     DELETE this block once the CollectionView and Adapter are implemented.
    */
    private let testStoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Test Habit Save/Load", for: .normal)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(helloLabel)
        
        // TEMPORARY: Adding test button to view
        view.addSubview(testStoreButton)
        testStoreButton.addTarget(self, action: #selector(runHabitStoreTest), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Standard UI Positioning
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            helloLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            helloLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            
            // TEMPORARY: Positioning test button at the bottom
            testStoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testStoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            testStoreButton.widthAnchor.constraint(equalToConstant: 220),
            testStoreButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Temporary Testing Logic

    /*
     TODO: Delete runHabitStoreTest() once the UI data flow is finalized.
     This confirms the Habit struct -> JSON -> Disk -> Habit struct cycle works.
    */
    @objc private func runHabitStoreTest() {
        print("\n--- Starting HabitStore Test: Seeding 3 Habits ---")
        
        let habitsToSeed: [Habit] = [
            Habit(
                id: UUID(),
                title: "Morning Run",
                scheduledType: .daily,
                customDaysBitmask: 127, // All 7 days (1+2+4+8+16+32+64)
                reminderEnabled: true,
                reminderTime: Date(),
                createdAt: Date(),
                isArchived: false
            ),
            Habit(
                id: UUID(),
                title: "Swift Coding",
                scheduledType: .weekdays,
                customDaysBitmask: 62, // Mon-Fri (2+4+8+16+32)
                reminderEnabled: true,
                reminderTime: nil,
                createdAt: Date(),
                isArchived: false
            ),
            Habit(
                id: UUID(),
                title: "Yoga",
                scheduledType: .custom,
                customDaysBitmask: 65, // Sun (1) and Sat (64)
                reminderEnabled: false,
                reminderTime: nil,
                createdAt: Date(),
                isArchived: false
            )
        ]
        
        // 1. Save the collection to disk
        store.save(habitsToSeed)
        
        // 2. Load all habits back from the Documents Directory
        let storedHabits = store.load()
        
        // 3. Print verification to console
        if storedHabits.isEmpty {
            print("Result: No habits found on disk.")
        } else {
            print("Result: Successfully retrieved \(storedHabits.count) habits.")
            
            storedHabits.forEach { habit in
                let status = habit.isArchived ? "Archived" : "Active"
                print("""
                ------------------------------------------
                Habit:  \(habit.title) (\(status))
                ID:     \(habit.id.uuidString.prefix(8))
                Type:   \(habit.scheduledType.rawValue)
                Indices: \(habit.activeDays)
                Bitmask: \(habit.customDaysBitmask ?? 0)
                ------------------------------------------
                """)
            }
            print("--- End of HabitStore Test ---")
        }
    }

}
