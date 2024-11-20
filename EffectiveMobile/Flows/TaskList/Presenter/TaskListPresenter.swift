//
//  TaskListPresenter.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation

protocol TaskListPresenterInput: AnyObject {
    
}

protocol TaskListPresenterOutput: AnyObject { }

final class TaskListPresenter {
    private let interactor: TaskListInteractorInput
    private let view: TaskListViewInput
    private let router: TaskListRouterInput
    
    init(interactor: TaskListInteractorInput, view: TaskListViewInput, router: TaskListRouterInput) {
        self.interactor = interactor
        self.view = view
        self.router = router
    }
}

extension TaskListPresenter: TaskListViewOutput {
    
    func getTasks() {
        interactor.getTasksList()
    }
    
    func changeTaskCompletionStatus(by id: Int) {
        interactor.updateTaskCompletion(by: id)
    }
    
    func goToSelectedTask(_ task: Task) {
        router.presentSelectedTask(with: task)
    }
}

extension TaskListPresenter: TaskListInteractorOutput {
    func sendTasks(from taskList: [Task]) {
        view.setTableData(with: taskList)
    }
    
    func sendError(withMessage: String, title: String) {
        
    }
}
