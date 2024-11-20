//
//  Task+CoreDataClass.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 19.11.2024.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject, Identifiable {
    @NSManaged public var completed: Bool
    @NSManaged public var id: Int
    @NSManaged public var todo: String?
    @NSManaged public var title: String
    @NSManaged public var createdAt: String

    func setupTask(id: Int, title: String = "Task", createdAt: String, todo: String, completed: Bool) {
        self.id = id
        self.title = title
        self.todo = todo
        self.createdAt = createdAt
        self.completed = completed
    }
}
