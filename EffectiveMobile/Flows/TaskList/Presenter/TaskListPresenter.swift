//
//  TaskListPresenter.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

// MARK: - handles requests and coordinates the work of the view and the interactor

final class TaskListPresenter {
    // MARK: - private properties
    private let interactor: TaskListInteractorInput
    private let view: TaskListViewInput
    private let router: TaskListRouterInput
    
    // MARK: - init
    init(interactor: TaskListInteractorInput, view: TaskListViewInput, router: TaskListRouterInput) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
}

// MARK: - handles requests from the view
extension TaskListPresenter: TaskListViewOutput {
    // MARK: - send a request to the interactor to get task list
    func getTasks() {
        interactor.getTasksList()
    }
    
    // MARK: - send a request to the interactor to update task completion status by ID
    func changeTaskCompletionStatus(by id: Int) {
        interactor.updateTaskCompletion(by: id)
    }
    
    // MARK: - send a request to the interactor to remove task by ID
    func removeTask(by id: Int) {
        interactor.removeTask(by: id)
    }
    
    // MARK: - send a request to the router present selected task
    func goToSelectedTask(by id: Int) {
        router.presentSelectedTask(by: id)
    }
    
    // MARK: - send a request to the router to open new task page with default data
    func createNewTask() {
        router.openTaskPage(by: nil)
    }
    
    // MARK: - send a request to the router to open selected task page to edit it
    func openTaskEditor(by id: Int) {
        router.openTaskPage(by: id)
    }
}

// MARK: - handles requests from the interactor
extension TaskListPresenter: TaskListInteractorOutput {
    // MARK: - send a request to the view to set received task list data
    func sendTasks(from taskList: [Task]) {
        view.setTableData(with: taskList)
    }
    
    // TODO: - send a request to the view to show alert controller
    func sendError(withMessage: String, title: String) { }
}
