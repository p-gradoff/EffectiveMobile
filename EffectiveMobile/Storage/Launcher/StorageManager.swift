//
//  CoreDataManager.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import CoreData

enum UpdateFormat {
    case completion(Bool)
    case filling(String)
}

enum StorageConstant {
    case storageName
    case entityName
    case sortParameter
    case idPredicate
    
    static func get(_ constant: StorageConstant) -> String {
        switch constant {
        case .storageName: "tasks"
        case .entityName: "task"
        case .sortParameter: "createdAt"
        case .idPredicate: "id == %@"
        }
    }
}


final class StorageManager {
    static let shared = StorageManager()
    private init() { }
    
    // TODO: - make error handling
    private let container: NSPersistentContainer = {
        $0.loadPersistentStores { description, error in
            if error == nil { print("Database: \(description)")}
        }
        return $0
    }(NSPersistentContainer(name: StorageConstant.get(.storageName)))
    
    private var context: NSManagedObjectContext { container.viewContext }
    
    // TODO: - make error handling
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Create new task
    func createtask(withID id: Int, toDo: String, isCompleted: Bool) {
        guard let taskDescription = NSEntityDescription.entity(forEntityName: StorageConstant.get(.entityName), in: context) else { return }
        
        let task = Task(entity: taskDescription, insertInto: context)
        task.setupTask(id: id, todo: toDo, completed: isCompleted)
        
        saveContext()
    }
    
    // MARK: - Fetch task by ID
    func fetchTask(byID id: Int) -> Task? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: StorageConstant.get(.entityName))
        fetchRequest.predicate = NSPredicate(format: StorageConstant.get(.idPredicate), id)
        
        let task = (try? context.fetch(fetchRequest) as? [Task])?.first
        return task
    }
    
    // MARK: - Fetch tasks and sort by createdAt date
    func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: StorageConstant.get(.entityName))
        let sortDesctiptor = NSSortDescriptor(key: StorageConstant.get(.sortParameter), ascending: false)
        fetchRequest.sortDescriptors = [sortDesctiptor]
        
        return (try? context.fetch(fetchRequest) as? [Task]) ?? []
    }
    
    // MARK: - Update task's completion status or to-do string
    func updateTask(with parameter: UpdateFormat, byID id: Int) {
        guard let task = fetchTask(byID: id) else {
            // MARK: - handle this error
            print("no such task")
            return
        }
        
        switch parameter {
        case .completion(let isCompleted): task.completed = isCompleted
        case .filling(let toDo): task.todo = toDo
        }
        
        saveContext()
    }
    
    // MARK: - Delete task by ID
    func removeTask(byID id: Int) {
        guard let task = fetchTask(byID: id) else {
            // MARK: - handle error
            return
        }
        
        context.delete(task)
        saveContext()
    }
}
