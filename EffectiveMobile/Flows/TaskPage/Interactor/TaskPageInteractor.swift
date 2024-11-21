//
//  TaskPageInteractor.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 21.11.2024.
//

import Foundation

// MARK: - allows to process requests to receive and send data from the presenter and view

protocol TaskPageInteractorInput: AnyObject {
    var output: TaskPageInteractorOutput? { get }
    func getTask(by id: Int)
    func getNewTask()
    func saveChanges(from title: String, _ description: String, with id: Int)
}

protocol TaskPageInteractorOutput: AnyObject {
    func sendTask(_ task: Task)
}

final class TaskPageInteractor {
    // MARK: - output is presenter
    weak var output: TaskPageInteractorOutput?
}

// MARK: - methods that allows the interactor to get information
extension TaskPageInteractor: TaskPageInteractorInput {
    // MARK: - sends a request to the store manager to get task by current ID
    func getTask(by id: Int) {
        // TODO: error handling
        guard let task = StorageManager.shared.fetchTask(by: id) else { return }
        output?.sendTask(task)
    }
    
    // MARK: - sends a request to the store manager to create a task and receives it
    func getNewTask() {
        let taskList: [Task] = StorageManager.shared.fetchTasks()
        let taskId = (taskList.first?.id ?? -1) + 1
        
        StorageManager.shared.createTask(
            with: taskId,
            createdAt: Date.now.formatDate(),
            toDo: "",
            isCompleted: false
        )
        
        let task = StorageManager.shared.fetchTask(by: taskId)
        // TODO: - error handling
        guard let task else { return }
        
        // MARK: - sends a request to the presenter to send task data to view
        output?.sendTask(task)
    }
    
    // MARK: - sends a request to the store manager to update task's data by ID
    func saveChanges(from title: String, _ description: String, with id: Int) {
        StorageManager.shared.updateTask(with: .filling(title: title, description: description), with: id)
    }
}
