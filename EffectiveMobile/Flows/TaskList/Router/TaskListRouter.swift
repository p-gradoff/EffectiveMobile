//
//  TaskListRouter.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import UIKit

protocol TaskListRouterInput: AnyObject {
    func presentSelectedTask(with task: Task)
}

final class TaskListRouter: TaskListRouterInput {
    weak var rootViewController: UIViewController?
    
    func presentSelectedTask(with task: Task) {
        let selectedTaskView = SelectedTaskConfigurator.configureSelectedTaskModule(with: task)
        
        selectedTaskView.delegate = rootViewController as? DismissDelegate
        rootViewController?.present(selectedTaskView, animated: true)
    }
}
