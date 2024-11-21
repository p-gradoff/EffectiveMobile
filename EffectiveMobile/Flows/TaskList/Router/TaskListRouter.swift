//
//  TaskListRouter.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import Foundation
import UIKit

protocol TaskListRouterInput: AnyObject {
    func presentSelectedTask(by id: Int)
    func openTaskPage(by id: Int?)
}

final class TaskListRouter: TaskListRouterInput {
    weak var rootViewController: UIViewController?
    
    func presentSelectedTask(by id: Int) {
        let selectedTaskView = SelectedTaskConfigurator.configureSelectedTaskModule(by: id) as! SelectedTaskView
        
        selectedTaskView.delegate = rootViewController as? DismissDelegate
        rootViewController?.present(selectedTaskView, animated: true)
    }
    
    func openTaskPage(by id: Int?) {
        let taskPageView = TaskPageConfigurator.configureTaskPageModule(by: id)
        
        rootViewController?.navigationController?.pushViewController(taskPageView, animated: true)
    }
}
