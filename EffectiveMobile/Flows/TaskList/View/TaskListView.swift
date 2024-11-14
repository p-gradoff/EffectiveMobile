//
//  TaskListView.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import UIKit

protocol TaskListViewInput: AnyObject {
    var output: TaskListViewOutput? { get set }
    // var Tasks: [Task] { get set }
    func setTableData(_ data: [Task])
}

protocol TaskListViewOutput: AnyObject {
    func getTasks()
}

final class TaskListView: UIViewController {
    private var tableData: [Task] = []
    var output: TaskListViewOutput?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension TaskListView: TaskListViewInput {
    func setTableData(_ data: [Task]) {
        tableData = data
    }
}
