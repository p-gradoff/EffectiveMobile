//
//  TaskPageConfigurator.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 21.11.2024.
//

import Foundation
import UIKit

// MARK: - configures the whole module

final class TaskPageConfigurator {
    static func configureTaskPageModule(by id: Int?) -> UIViewController {
        let view = TaskPageView()
        let interactor = TaskPageInteractor()
        let presenter = TaskPagePresenter(view: view, interactor: interactor)
        
        view.output = presenter
        interactor.output = presenter
        
        // starts loading the task before the view appears
        presenter.setTask(by: id)
        
        return view
    }
}
