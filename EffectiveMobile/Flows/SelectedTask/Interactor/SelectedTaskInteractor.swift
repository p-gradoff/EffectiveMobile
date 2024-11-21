//
//  SelectedTaskInteractor.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import Foundation

// MARK: - allows to process requests to receive and send data from the presenter and view

protocol SelectedTaskInteractorInput: AnyObject {
    var output: SelectedTaskInteractorOutput? { get }
    func getTableData()
    func getTask(by id: Int)
}

protocol SelectedTaskInteractorOutput: AnyObject {
    func sendData(_ data: [EditData])
    func sendTask(_ task: Task)
}

final class SelectedTaskInteractor: SelectedTaskInteractorInput {
    // MARK: - output is presenter
    weak var output: SelectedTaskInteractorOutput?
    
    // MARK: - sends a request to the EditData structure to get tableData and then send it to view via presenter
    func getTableData() {
        let data = EditData.getEditData()
        output?.sendData(data)
    }
    
    // MARK: - send a request to the store manager to get task by ID and then send it to view via presenter
    func getTask(by id: Int) {
        guard let task = StorageManager.shared.fetchTask(by: id) else {
            print("no such task")
            return
        }
        output?.sendTask(task)
    }
}
