//
//  CoreDataManager.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import CoreData

enum UpdateFormat {
    case completion
    case filling(String)
}

enum StorageConstant {
    case storageName
    case entityName
    case sortParameterDate
    case sortParameterID
    case idPredicate
    
    static func get(_ constant: StorageConstant) -> String {
        switch constant {
        case .storageName: "Task"
        case .entityName: "Task"
        case .sortParameterDate: "createdAt"
        case .sortParameterID: "id"
        case .idPredicate: "id == %ld"
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
    func createTask(withID id: Int, createdAt date: String, toDo text: String, isCompleted status: Bool) {
        guard let taskDescription = NSEntityDescription.entity(
            forEntityName: StorageConstant.get(.entityName),
            in: context
        ) else {
            return
        }
        
        let task = Task(entity: taskDescription, insertInto: context)
        task.setupTask(id: id, createdAt: date, todo: text, completed: status)
        
        saveContext()
    }
    
    // MARK: - Fetch task by ID
    func fetchTask(byID id: Int) -> Task? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: StorageConstant.get(.entityName))
        let predicate = NSPredicate(format: StorageConstant.get(.idPredicate), id as CLong)
        fetchRequest.predicate = predicate
        
        let task = (try? context.fetch(fetchRequest) as? [Task])?.first
        return task
    }
    
    // MARK: - Fetch tasks and sort by createdAt date
    func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: StorageConstant.get(.entityName))
        let sortDesctiptorID = NSSortDescriptor(key: StorageConstant.get(.sortParameterID), ascending: false)
        let sortDesctiptorDate = NSSortDescriptor(key: StorageConstant.get(.sortParameterDate), ascending: false)
        fetchRequest.sortDescriptors = [sortDesctiptorDate, sortDesctiptorID]
        
        return (try? context.fetch(fetchRequest) as? [Task]) ?? []
    }
    
    // MARK: - Update task's completion status or to-do string
    func updateTask(with parameter: UpdateFormat, by id: Int) {
        guard let task = fetchTask(byID: id) else {
            // MARK: - handle this error
            print("no such task")
            return
        }
        
        print(task.completed)
        switch parameter {
        case .completion: task.completed.toggle()
        case .filling(let toDo): task.todo = toDo
        }
        print(task.completed)
        
        saveContext()
    }
    
    // MARK: - Delete task by ID
    func removeTask(by id: Int) {
        guard let task = fetchTask(byID: id) else {
            // MARK: - handle error
            return
        }
        
        context.delete(task)
        saveContext()
    }
}
