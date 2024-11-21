//
//  TaskListRouter.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import UIKit

// MARK: - controls opening and closing of modules

protocol TaskListRouterInput: AnyObject {
    func presentSelectedTask(by id: Int)
    func openTaskPage(by id: Int?)
}

final class TaskListRouter: TaskListRouterInput {
    // MARK: - parent view controller
    weak var rootViewController: UIViewController?
    
    // MARK: - present selected task by ID
    func presentSelectedTask(by id: Int) {
        let selectedTaskView = SelectedTaskConfigurator.configureSelectedTaskModule(by: id) as! SelectedTaskView
        
        selectedTaskView.delegate = rootViewController as? DismissDelegate
        rootViewController?.present(selectedTaskView, animated: true)
    }
    
    // MARK: - open new task page or existing task page by id
    func openTaskPage(by id: Int?) {
        let taskPageView = TaskPageConfigurator.configureTaskPageModule(by: id)
        
        rootViewController?.navigationController?.pushViewController(taskPageView, animated: true)
    }
}
