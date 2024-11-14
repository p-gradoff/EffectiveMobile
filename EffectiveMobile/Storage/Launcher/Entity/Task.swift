//
//  Note.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject, Identifiable {
    @NSManaged public var id: Int
    @NSManaged public var createdAt: Date
    @NSManaged public var todo: String
    @NSManaged public var completed: Bool
    
    func setupTask(id: Int, todo: String, completed: Bool) {
        self.id = id
        self.todo = todo
        self.completed = completed
    }
}


