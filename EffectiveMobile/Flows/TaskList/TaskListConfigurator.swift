//
//  TaskListConfigurator.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import UIKit

// MARK: - configures the whole module

final class TaskListConfigurator {
    static func configureTaskListModule() -> UIViewController {
        let networkManager = NetworkManager()
        
        let view = TaskListView()
        let router = TaskListRouter()
        let interactor = TaskListInteractor(networkManager: networkManager)
        let presenter = TaskListPresenter(interactor: interactor, view: view, router: router)
        
        view.output = presenter
        interactor.output = presenter
        router.rootViewController = view
        
        return view
    }
}
