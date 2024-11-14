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
}

protocol TaskListInteractorOutput: AnyObject {
    
}

final class TaskListInteractor: TaskListInteractorInput {
    weak var output: TaskListInteractorOutput?
    
    private let networkManager: NetworkOutput
    // private let storageManager: 
    
    private var isInitialLaunch: Bool {
        LaunchManager.isInitialLaunch()
    }
    
    init(networkManager: NetworkOutput) {
        self.networkManager = networkManager
    }
    
    func getTasksList() {
        if isInitialLaunch {
            networkManager.doRequest { result in
//                switch result {
//                case .success(let tasksList): // convert to [Task] and send
//                case .failure(let err): // call sendError
//                }
            }
        } else {
            
        }
    }
}

extension TaskListInteractor: TaskListPresenterOutput {
    
}
