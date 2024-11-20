//
//  SelectedTaskInteractor.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import Foundation

protocol SelectedTaskInteractorInput: AnyObject {
    var output: SelectedTaskInteractorOutput? { get }
    func removeTask(by id: Int)
    func getTableData()
}

protocol SelectedTaskInteractorOutput: AnyObject {
    func sendData(_ data: [EditData])
}

final class SelectedTaskInteractor: SelectedTaskInteractorInput {
    weak var output: SelectedTaskInteractorOutput?
    
    func removeTask(by id: Int) {
        StorageManager.shared.removeTask(by: id)
    }
    
    func getTableData() {
        let data = EditData.getEditData()
        output?.sendData(data)
    }
}
