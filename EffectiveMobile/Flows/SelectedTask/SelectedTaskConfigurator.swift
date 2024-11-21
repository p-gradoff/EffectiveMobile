//
//  SelectedTaskConfigurator.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 20.11.2024.
//

import Foundation
import UIKit

// MARK: - configures the whole module

final class SelectedTaskConfigurator {
    static func configureSelectedTaskModule(by id: Int) -> UIViewController {
        let view = SelectedTaskView()
        let interactor = SelectedTaskInteractor()
        let presenter = SelectedTaskPresenter(view: view, interactor: interactor)
        
        view.output = presenter
        interactor.output = presenter
        
        // starts loading the task before the view appears
        presenter.setTask(by: id)
        
        return view
    }
}
