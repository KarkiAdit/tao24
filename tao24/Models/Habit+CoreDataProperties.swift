//
//  Habit+CoreDataProperties.swift
//  tao24
//
//  Created by Aditya Karki on 4/8/26.
//
//

public import Foundation
public import CoreData


public typealias HabitCoreDataPropertiesSet = NSSet

extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var lastCompleted: Date?
    @NSManaged public var streak: Int16
    @NSManaged public var title: String?

}

extension Habit : Identifiable {

}
