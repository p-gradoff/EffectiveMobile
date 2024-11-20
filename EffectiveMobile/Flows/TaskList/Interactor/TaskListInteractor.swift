//
//  TaskListInteractor.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

protocol TaskListInteractorInput: AnyObject {
    var output: TaskListInteractorOutput? { get }
    func getTasksList()
    func updateTaskCompletion(by id: Int)
}

protocol TaskListInteractorOutput: AnyObject {
    func sendError(withMessage: String, title: String)
    func sendTasks(from taskList: [Task])
}

final class TaskListInteractor: TaskListInteractorInput {
    weak var output: TaskListInteractorOutput?
    
    private let networkManager: NetworkOutput
    
    private var isInitialLaunch: Bool {
        LaunchManager.isInitialLaunch()
    }
    
    init(networkManager: NetworkOutput) {
        self.networkManager = networkManager
    }
    
    private func saveInitialTaskList(_ list: [RawTask]) {
        for task in list {
            StorageManager.shared.createTask(
                withID: task.id,
                createdAt: Date.now.formatDate(),
                toDo: task.todo,
                isCompleted: task.completed
            )
        }
    }
    
    private func getTasksFromStorage() -> [Task] {
        let taskList: [Task] = StorageManager.shared.fetchTasks()
        return taskList
    }
    
    func getTasksList() {
        if isInitialLaunch {
            let dispatchgGroup = DispatchGroup()
            dispatchgGroup.enter()
            networkManager.doRequest { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let tasksList): // convert to [Task] and save, then send
                    saveInitialTaskList(tasksList.todos)
                    // let taskList = getTasksFromStorage()
                    // output?.sendTasks(from: taskList)
                case .failure(let err):
                    output?.sendError(withMessage: NetworkError.get(err), title: err.rawValue)
                }
                dispatchgGroup.leave()
            }
            dispatchgGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                
                let taskList = getTasksFromStorage()
                output?.sendTasks(from: taskList)
            }
        }
//        else {
//            let taskList = getTasksFromStorage()
//            output?.sendTasks(from: taskList)
//        }
        let taskList = getTasksFromStorage()
        output?.sendTasks(from: taskList)
    }
    
    func updateTaskCompletion(by id: Int) {
        StorageManager.shared.updateTask(with: .completion, by: id)
    }
}

extension TaskListInteractor: TaskListPresenterOutput {
    
}
