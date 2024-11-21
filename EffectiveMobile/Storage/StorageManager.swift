//
//  CoreDataManager.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import CoreData

// MARK: - Core Data manager that controls access to the storage

// MARK: - possible ways to change task data
enum UpdateFormat {
    case completion
    case filling(title: String, description: String)
}

// MARK: - storage constants for easy using
enum StorageConstant {
    case name
    case sortParameterDate
    case sortParameterID
    case idPredicate
    
    static func get(_ constant: StorageConstant) -> String {
        switch constant {
        case .name: "Task"
        case .sortParameterDate: "createdAt"
        case .sortParameterID: "id"
        case .idPredicate: "id == %ld"
        }
    }
}


final class StorageManager {
    // MARK: - singletone
    static let shared = StorageManager()
    private init() { }
    
    // TODO: - make error handling
    private let container: NSPersistentContainer = {
        $0.loadPersistentStores { description, error in
            if error != nil {
                // TODO: - error handling
            }
        }
        return $0
    }(NSPersistentContainer(name: StorageConstant.get(.name)))
    
    private var context: NSManagedObjectContext { container.viewContext }
    
    // MARK: - save changes in context
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: - error handling
            }
        }
    }
    
    // MARK: - create new task and save
    func createTask(with id: Int, createdAt date: String, toDo text: String, isCompleted status: Bool) {
        guard let taskDescription = NSEntityDescription.entity(
            forEntityName: StorageConstant.get(.name),
            in: context
        ) else {
            // TODO: - error handling
            return
        }
        
        let task = Task(entity: taskDescription, insertInto: context)
        task.setupTask(id: id, createdAt: date, todo: text, completed: status)
        
        saveContext()
    }
    
    // MARK: - fetch task by ID
    func fetchTask(by id: Int) -> Task? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: StorageConstant.get(.name))
        let predicate = NSPredicate(format: StorageConstant.get(.idPredicate), id as CLong)
        fetchRequest.predicate = predicate
        
        let task = (try? context.fetch(fetchRequest) as? [Task])?.first
        return task
    }
    
    // MARK: - fetch tasks and sort by createdAt date
    func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: StorageConstant.get(.name))
        let sortDesctiptorID = NSSortDescriptor(key: StorageConstant.get(.sortParameterID), ascending: false)
        let sortDesctiptorDate = NSSortDescriptor(key: StorageConstant.get(.sortParameterDate), ascending: false)
        fetchRequest.sortDescriptors = [sortDesctiptorDate, sortDesctiptorID]
        
        return (try? context.fetch(fetchRequest) as? [Task]) ?? []
    }
    
    // MARK: - update task data and save
    func updateTask(with parameter: UpdateFormat, with id: Int) {
        guard let task = fetchTask(by: id) else {
            // TODO: - error handling
            return
        }
        
        switch parameter {
        case .completion: task.completed.toggle()
        case .filling(let title, let description):
            task.title = title
            task.todo = description
        }
        
        saveContext()
    }
    
    // MARK: - delete task by ID and save
    func removeTask(by id: Int) {
        guard let task = fetchTask(by: id) else {
            // TODO: - error handling
            return
        }
        
        context.delete(task)
        saveContext()
    }
}
