//
//  SelectedTaskPresenter.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import Foundation

protocol SelectedTaskPresenterInput: AnyObject {
    func sendTaskData(_ task: Task)
}

final class SelectedTaskPresenter {
    private var view: SelectedTaskViewInput
    private var interactor: SelectedTaskInteractorInput
    
    init(view: SelectedTaskViewInput, interactor: SelectedTaskInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
}

extension SelectedTaskPresenter: SelectedTaskPresenterInput {
    func sendTaskData(_ task: Task) {
        view.setSelectedTask(task)
    }
}

extension SelectedTaskPresenter: SelectedTaskViewOutput {
    func getEditTableData() {
        interactor.getTableData()
    }
    
    func removeTask(by id: Int) {
        interactor.removeTask(by: id)
    }
}

extension SelectedTaskPresenter: SelectedTaskInteractorOutput {
    func sendData(_ data: [EditData]) {
        view.setTableData(with: data)
    }
}


