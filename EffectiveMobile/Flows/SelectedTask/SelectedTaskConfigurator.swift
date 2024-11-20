//
//  SelectedTaskConfigurator.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import Foundation
import UIKit

final class SelectedTaskConfigurator {
    static func configureSelectedTaskModule(with task: Task) -> SelectedTaskView {
        let view = SelectedTaskView()
        let interactor = SelectedTaskInteractor()
        let presenter = SelectedTaskPresenter(view: view, interactor: interactor)
        
        view.output = presenter
        interactor.output = presenter
        presenter.sendTaskData(task)
        
        return view
    }
}
