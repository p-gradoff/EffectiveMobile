//
//  TaskListInteractor.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

// MARK: - allows to process requests to receive and send data from the presenter and view

protocol TaskListInteractorInput: AnyObject {
    var output: TaskListInteractorOutput? { get }
    func getTasksList()
    func updateTaskCompletion(by id: Int)
    func removeTask(by id: Int)
}

protocol TaskListInteractorOutput: AnyObject {
    func sendError(withMessage: String, title: String)
    func sendTasks(from taskList: [Task])
}

final class TaskListInteractor: TaskListInteractorInput {
    // MARK: - output is presenter
    weak var output: TaskListInteractorOutput?
    
    // MARK: - private properties
    private let networkManager: NetworkOutput
    private var isInitialLaunch: Bool {
        // first program launch check
        LaunchManager.isInitialLaunch()
    }
    
    // MARK: - init
    init(networkManager: NetworkOutput) {
        self.networkManager = networkManager
    }
    
    // MARK: - for each raw task sends a request to store manager to get it's data and create task
    private func saveInitialTaskList(_ list: [RawTask]) {
        for task in list {
            StorageManager.shared.createTask(
                with: task.id,
                createdAt: Date.now.formatDate(),
                toDo: task.todo,
                isCompleted: task.completed
            )
        }
    }
    
    // MARK: - send a request to the store manager to get task list that contains all created tasks
    private func getTasksFromStorage() -> [Task] {
        let taskList: [Task] = StorageManager.shared.fetchTasks()
        return taskList
    }
    
    // MARK: - method that manages tasks receiving depending on isInitialLaunch property. If true, loads from network. Then send save them
    func getTasksList() {
        if isInitialLaunch {
            // MARK: - prepare for asynchronous work
            let dispatchgGroup = DispatchGroup()
            dispatchgGroup.enter()
            // MARK: - do network request to get raw task list
            networkManager.doRequest { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                // MARK: - if success then handle received raw task list and save
                case .success(let tasksList):
                    saveInitialTaskList(tasksList.todos)
                // MARK: - if failure then send an error to the presenter to show
                case .failure(let err):
                    // TODO: - handle error
                    let _ = err
                    // output?.sendError(withMessage: NetworkError.get(err), title: err.rawValue)
                }
                dispatchgGroup.leave()
            }
            dispatchgGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                
                // MARK: - get tasks and then send it to view via presenter
                let taskList = getTasksFromStorage()
                output?.sendTasks(from: taskList)
            }
        } else {
            // MARK: - get tasks and then send it to view via presenter
            let taskList = getTasksFromStorage()
            output?.sendTasks(from: taskList)
        }
    }
    
    // MARK: - send a request to the store manager to update completion status of task by ID
    func updateTaskCompletion(by id: Int) {
        StorageManager.shared.updateTask(with: .completion, with: id)
    }
    
    // MARK: - send a request to the store manager to remove task by ID
    func removeTask(by id: Int) {
        StorageManager.shared.removeTask(by: id)
    }
}
